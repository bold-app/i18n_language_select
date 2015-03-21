require 'yaml'
require 'open-uri'
require 'nokogiri'


begin
  require 'threach'
rescue LoadError
  # Importing should be done on dev
end

# Imports ISO 639-1 country codes
# It parses a HTML file from Unicode.org for given locale and saves the
# Rails' I18n hash in the plugin +locale+ directory
module I18nLanguageSelect
  class Import
    attr_accessor :output_dir
    attr_reader :locales

    def initialize(locales = nil, namespace=nil)
      @namespace = namespace || I18nLanguageSelect.configuration.namespace.to_s
      @locales = if locales
        locales.split(",")
      else
        fetch_locales
      end
      if @locales && @locales.length
        puts "Gathering languages from unicode.org using the namespace '#{@namespace}' and the locales: #{@locales.join(', ')}"
      else
        puts "Unable to gather languages. No locales specified. Either specifiy locales using the environment variable LOCALES, or install the i18n gem."
      end
    end

    def process
      @locales.threach(4, :each_with_index) do |locale, index|
        puts "Processing: #{locale}"
        # ----- Get the CLDR HTML     --------------------------------------------------
        begin
          doc = Nokogiri::HTML(open("http://www.unicode.org/cldr/charts/latest/summary/#{locale}.html"))
        rescue => e
          puts "[!] Invalid locale name '#{locale}'! Not found in CLDR (#{e})"
          return if index == @locales.length - 1
        end

        languages = search_for_languages(doc)
        if languages.keys.length
          # ----- Parse the HTML with Nokogiri ----------------------------------------
          output = { locale => { @namespace => languages } }
          # ----- Write the parsed values into file      ---------------------------------
          write_for(locale, output)
        end
      end
    end

    private

    def search_for_languages(doc)
      result = {}
      doc.search("//tr").each do |row|
        if row_is_language?(row)
          code_cell  = row.search("td[@class='g']").last
          value_cell = row.search("td[@class='v']").first

          if value_cell
            r = /([A-Za-z\-_0-9]+)/ # to sanitize the language code
            match = r.match(code_cell.inner_text)
            code   = match[0] if match
            name   = value_cell.inner_text
            # if code and name are the same, then translation doesn't exist and best to
            # not include anything so developer can choose own fallback.
            result.update(code.to_s => name.to_s) unless code.to_s == name.to_s
          end
        end
      end
      # result.sort_by { |key, value| key }.to_h works in Ruby 2.x
      Hash[result.sort_by { |key, value| key }]
    end

    def row_is_language?(row)
      primary    = row.search("td[@class='n']")
      secondary  = row.search("td[@class='g']")

      has_locale_cell = primary.first && primary.first.inner_text =~ /^Locale Display Names$/
      primary_has_language_cell = primary[1] && primary[1].inner_text =~ /^Languages/
      secondary_has_language_cell = secondary.first && secondary.first.inner_text =~ /^Languages/

      has_locale_cell && (primary_has_language_cell || secondary_has_language_cell)
    end

    def fetch_locales
      puts "Fetching available locales from unicode.org."
      begin
        doc = Nokogiri::HTML(open("http://www.unicode.org/cldr/charts/latest/summary/root.html"))
        doc.css("p a").map{|link| link['href']}.map do |url|
          m = /([A-za-z]+).html/.match(url)
          m[1] if m && m[1] != "root"
        end.compact.uniq
      rescue => e
        puts "[!] Unable to fetch unitcode root for locales (#{e})."
        []
      end
    end


    def write_for(locale, output)
      puts "\n... writing the output"
      filename = File.join(Dir.pwd, "#{@namespace}.#{locale}.yml")
      File.rename(filename, filename + ".OLD") if File.exists?(filename) # Rename by appending 'OLD' if file exists
      File.open(filename, "w+") { |f| f << output.to_yaml }
      puts "\n---\nWritten values for the '#{locale}' into file: #{filename}\n"
    end
  end
end
