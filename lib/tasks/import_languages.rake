require 'rubygems'
require 'open-uri'
require 'i18n_language_select/import'

# Rake task for importing language names from Unicode.org's CLDR repository
# (http://www.unicode.org/cldr/data/charts/summary/root.html).
#
# It parses a HTML file from Unicode.org for given locale and saves the
# Rails' I18n hash in the plugin +locale+ directory
#
namespace :i18n_language_select do

  desc "Import language codes and names for various languages from the Unicode.org CLDR archive."
  task :import do
    begin
      require 'nokogiri'
    rescue LoadError
      puts "Error: Nokogiri library required to use this task (import:language_translations)"
      exit
    end

    import = I18nLanguageSelect::Import.new(ENV['LOCALES'], ENV['NAMESPACE'])
    import.process
  end
end
