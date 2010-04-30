require File.expand_path("../alias_method_chain_once", __FILE__)

module ActionView
  module Helpers
    module TagHelper
      # `tag` is called by all helpers
    end

    module FormTagHelper
      # `extra_tags_for_form` is called when `form_tag` with block finished,
      # usually to add authenticity_token to POST forms

      # `form_tag`, also called by `form_for`
      def form_tag_with_never_forget_multipart(*args, &block)
        # no way for us to track inputs added to the form when `form_tag` is
        # used just to generate opening tag
        return form_tag_without_never_forget_multipart(*args, &block) unless block

        form_options = args[1]
        form_html = form_tag_without_never_forget_multipart(*args, &block)

        NeverForgetMultipart.check_form(form_options, form_html, :form_tag)

        form_html
      end

      alias_method_chain_once :form_tag, :never_forget_multipart
    end

    module FormHelper
      def form_for_with_never_forget_multipart(*args, &block)
        form_options = args[-1].is_a?(Hash) && args[-1][:html]

        new_block = Proc.new do |*block_args|
          form_html = block.call(*block_args)

          NeverForgetMultipart.check_form(form_options, form_html, :form_for)

          form_html
        end

        form_for_without_never_forget_multipart(*args, &new_block)
      end

      alias_method_chain_once :form_for, :never_forget_multipart
    end
  end
end
