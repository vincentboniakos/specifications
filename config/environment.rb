# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Specifications::Application.initialize!
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag =~ /<(input|textarea|select)[^>]/
    if instance.error_message.kind_of?(Array)
      %(#{html_tag}<span class="help-inline">&nbsp;
      #{instance.error_message.join(',')}</span>).html_safe
    else
      %(#{html_tag}<span class="help-inline">&nbsp;
      #{instance.error_message}</span>).html_safe
    end
  else
    html_tag
  end
end


