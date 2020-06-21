require "form_builder/engine"
require "form_builder/builder"

module FormBuilder
  def dashboard_form_for(object, *args, &block)
    options = args.extract_options!
    args << options.merge(builder: Builder)
    form_for(object, *args, &block)
  end
end
