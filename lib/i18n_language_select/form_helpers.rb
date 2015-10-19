module I18nLanguageSelect
  module FormHelpers
    def language_code_select(object_name, method, priority_languages = nil, options = {}, html_options = {})
      if Rails::VERSION::MAJOR >= 4
        instance_tag = ActionView::Helpers::Tags::Select.new(object_name, method, self, [], options, html_options).to_language_code_select_tag(priority_languages, html_options)
      else
        instance_tag = ActionView::Helpers::InstanceTag.new(object_name, method, self, options.delete(:object)).to_language_code_select_tag(priority_languages, html_options, options)
      end
    end
  end
end
