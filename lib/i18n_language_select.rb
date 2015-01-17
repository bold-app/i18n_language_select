require "i18n_language_select/version"
require "i18n_language_select/form_helpers"
require "i18n_language_select/instance_tag"
require "i18n_language_select/form_builder"
require "i18n_language_select/import"
require 'i18n_language_select/railtie' if defined?(Rails)

module I18nLanguageSelect

  class << self

    def configuration
      @configuration ||= Configuration.new
    end

    def configuration=(config)
      @configuration = config
    end

    def configure
      yield(configuration)
    end

  end

  class Configuration
    attr_accessor :namespace,             # namespace of locales for language options
                  :custom,                # if true, do not load locales from gem
                  :available_locales_only # if true and custom is false, only load app's locales from gem

    def initialize
      self.namespace              = "i18n_languages"
      self.custom                 = false
      self.available_locales_only = true
    end
  end


end

ActionView::Base.send(:include, I18nLanguageSelect::FormHelpers)
if Rails::VERSION::MAJOR >= 4
  ActionView::Helpers::ActiveModelInstanceTag.send(:include, I18nLanguageSelect::InstanceTag)
else
  ActionView::Helpers::InstanceTag.send(:include, I18nLanguageSelect::InstanceTag)
end
ActionView::Helpers::FormBuilder.send(:include, I18nLanguageSelect::FormBuilder)
