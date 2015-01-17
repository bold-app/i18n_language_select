module I18nLanguageSelect
  class Railtie < Rails::Railtie
    initializer 'i18n_language_select' do |app|
      I18nLanguageSelect::Railtie.instance_eval do

        unless I18nLanguageSelect.configuration.custom
          which_locals = if I18nLanguageSelect.configuration.available_locales_only
            app.config.i18n.available_locales
          else
            nil
          end
          pattern = pattern_from(which_locals)
          add("locales/i18n_languages.#{pattern}.yml")
        end
      end
    end

    rake_tasks do
      load "tasks/import_languages.rake"
    end

    protected

    def self.add(pattern)
      files = Dir[File.join(File.dirname(__FILE__), '../', pattern)]
      I18n.load_path.concat(files)
    end

    def self.pattern_from(args)
      array = Array(args || [])
      array.blank? ? '*' : "{#{array.join ','}}"
    end

  end
end
