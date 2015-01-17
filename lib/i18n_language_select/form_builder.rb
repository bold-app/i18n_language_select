module I18nLanguageSelect
	module FormBuilder
		def language_code_select(method, priority_languages = nil, options = {}, html_options = {})
			@template.language_code_select(@object_name, method, priority_languages, options.merge(object: @object), html_options)
		end
	end
end
