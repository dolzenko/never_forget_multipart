## Never Forget Multipart

How many times did you forget to include that `:multipart => true` option
pulling your hair out while trying to figure why this particular upload
is not working?

Damn even [**Struts**](http://svn.apache.org/viewvc/struts/struts2/trunk/core/src/main/java/org/apache/struts2/components/File.java?revision=582626&view=markup#l76)
gives you the warning when file component is included in 
form which doesn't have `enctype="multipart/form-data"` set.

Let's fix that

    rails plugin install git://github.com/dolzenko/never_forget_multipart.git

Now whenever you do something stupid like

    <%= form_tag do %>
      <%= file_field_tag :wont_work %>
    <% end %>

The `NeverForgetMultipart::NeverForgetMultipartException` exception with the
following message will be raised

    it looks like you have included file input field
    on the form without setting forms `:multipart => true' option.
    To do so pass :html => { :multipart => true } as the last parameter to the form_for
    helper like this: form_for(@user, :html => { :multipart => true })

Cool, eh?    