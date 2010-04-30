class NeverForgetMultipart
  class NeverForgetMultipartException < ArgumentError
  end
  
  FILE_INPUT_REGEXP = /<input[^>]+type=['"]*file['"]*/
  
  ADVICES = {
    :form_tag => "pass :multipart => true as the last parameter to the form_tag\n" \
      "helper like this: form_tag('/upload', :multipart => true)",
    :form_for => "pass :html => { :multipart => true } as the last parameter to the form_for\n" \
      "helper like this: form_for(@user, :html => { :multipart => true })"
  }
  
  def self.check_form(form_options, form_html, helper_type)
    return unless Rails.env.development?
    
    non_multipart_form = form_options.blank? ||
            form_options.is_a?(Hash) && !form_options.with_indifferent_access[:multipart]
    
    if non_multipart_form && form_html =~ FILE_INPUT_REGEXP
      raise NeverForgetMultipartException, "it looks like you have included file input field \n" <<
                                            "on the form without setting forms `:multipart => true' option.\n" <<
                                            "To do so #{ ADVICES[helper_type] }"
    end
  end
end