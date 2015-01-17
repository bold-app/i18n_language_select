require 'rubygems'
require 'json'
require 'yaml'

# This is a quick and dirty script to keep language codes based on whatever is specified
# in the english language set. Much work needs to be done to standardize across all
# languages provided.

folder_path = "lib/locales"
file_path = File.join(folder_path, "i18n_languages.en.yml")
languages = YAML.load_file(file_path)
acceptable_codes = languages['en']['i18n_languages'].keys
puts "There are #{acceptable_codes.size} acceptable language codes specified in '#{file_path}'."

# In each remaining language file, blast away entries that don't match acceptable codes
# and re-write the files.
Dir.glob("#{folder_path}/*.yml").each do |path|
  yaml = YAML.load_file(path)
  code = yaml.keys.first
  puts "Checking '#{code}'"
  languages_yaml = yaml[code]
  namespace = languages_yaml.keys.first
  languages = languages_yaml[namespace]
  puts "Found #{languages.size} language codes."
  languages.keep_if{|k, v| acceptable_codes.include?(k)}
  puts "Keeping #{languages.size} languages."
  File.open(path, 'w') do |f|
    f.write(yaml.to_yaml)
  end
end


Dir.glob("#{folder_path}/*.yml").each do |path|
  yaml = YAML.load_file(path)
  code = yaml.keys.first
  languages_yaml = yaml[code]
  namespace = languages_yaml.keys.first
  languages = languages_yaml[namespace]

  missing = []
  acceptable_codes.each do |code|
    missing << code unless languages.include?(code)
  end

  unless missing.empty?
    puts "'#{code}' is missing locales: #{missing.join(", ")}"
  end

end
