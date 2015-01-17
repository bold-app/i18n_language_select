module I18nLanguageSelect
  module InstanceTag

    def to_language_code_select_tag(priority_languages, html_options = {}, options = {})
      # Rails 4 stores options sent when creating an InstanceTag.
      # Let's use them!
      options = @options if defined?(@options)

      language_code_select(priority_languages, options, html_options)
    end

    # Adapted from Rails language_select. Just uses language codes instead of full names.
    def language_code_select(priority_languages, options, html_options)
      selected = object.send(@method_name) if object.respond_to?(@method_name)

      languages = ""

      if options.present? and options[:include_blank]
        option = options[:include_blank] == true ? "" : options[:include_blank]
        languages += "<option>#{option}</option>\n"
      end

      if priority_languages
        languages += options_for_select(priority_languages, selected)
        languages += "<option value=\"\" disabled=\"disabled\">-------------</option>\n"
      end

      languages = languages + options_for_select(language_translations, selected)

      html_options = html_options.stringify_keys
      add_default_name_and_id(html_options)

      content_tag(:select, languages.html_safe, html_options)
    end

    def language_translations
      I18n.t(I18nLanguageSelect.configuration.namespace.to_s).map do |pairing|
        [pairing[1], pairing[0]] if pairing[0] && pairing[1]
      end.compact.sort_by do |pairing|
        pairing[0] # sort by language name alphabetical
      end
    end


  end
end
