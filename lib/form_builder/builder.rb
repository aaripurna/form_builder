
class FormBuilder::Builder < ::ActionView::Helpers::FormBuilder
	attr_reader :object

  def image(attribute, args={})
    args[:name] = set_name(attribute, args)
    args[:attribute] = attribute
    args[:src] ||= @template.url_for(saved_value(attribute).variant(resize: "200x200")) if saved_value(attribute).attached?
    args[:id] ||= args[:name].parameterize
    args[:errors] ||= get_errors(attribute)
    @template.render "partials/form_builder/image_field", args: args
  end

  def destroy(url)
    name = object.class.name.titleize
    if object.id.present?
      @template.content_tag(:button, "Delete #{name}", {class: "form-delete form-delete-auto", type: :button , data: {url: url}})
    end
  end

  def form_block(args = {}, &block)
    @template.render "partials/form_builder/form_block", args: args do
      @template.capture(&block)
    end
  end

  def slug(attribute, args={})
    args[:name] = set_name(attribute, args)
    args[:value] ||= saved_value(attribute)
    args[:target_id] ||= set_name(args[:target]).parameterize
    @template.render "partials/form_builder/slug_field", args: args.except(:target)
  end

  def label(attribute, args={}, &block)
    args[:for] ||= set_name(attribute, args).parameterize
    @template.render "partials/form_builder/form_label",
      attribute: args[:text] || attribute.to_s.titleize, args: args do
      @template.capture(&block) if block_given?
    end
  end

  def text(attribute, args ={})
    args[:name] = set_name(attribute, args)
    args[:value] ||= saved_value(attribute)
    args[:id] ||= args[:name].parameterize
    args[:errors] ||= get_errors(attribute)
    @template.render "partials/form_builder/text_field", args: args
  end

  def date(attribute, args={})
    args[:name] = set_name(attribute, args)
    value = if saved_value(attribute).present? && saved_value(attribute).is_a?(Time)
              saved_value(attribute)
            else
              args[:default] || Time.zone.now
            end
    args[:value] ||= value.strftime("%Y-%m-%e")
    args[:id] ||= args[:name].parameterize
    @template.render "partials/form_builder/date_picker_field", args: args
  end

  def galleries(attribute, args={})
    args[:name] = set_name(attribute, args)
    args[:id] = args[:name].parameterize
    args[:'data-params'] = "#{@object_name}[#{attribute.to_s.singularize}_ids][]"
    args[:galleries] = @object.send(attribute).attachments.map {|g| g.blob.id}&.join(',')
    @template.render "partials/form_builder/multiple_upload", args: args
  end

  def textarray(attribute, args={})
    args[:multiple] = true
    args[:name] = set_name(attribute, args)
    args[:id] ||= args[:name].parameterize
    args[:value] ||= saved_value(attribute)
    @template.render "partials/form_builder/text_array_field", args: args
  end

  def textarea(attribute, args={})
    args[:name] = set_name(attribute, args)
    args[:value] ||= saved_value(attribute)
    args[:id] ||= args[:name].parameterize
    args[:errors] ||= get_errors(attribute)
    @template.render "partials/form_builder/textarea_field", args: args
  end

  def children_for(attribute, args={}, &block)
    @template.content_tag(:div, {**args}) do
      fields_for(attribute, &block)
    end
  end


  def date_range(args={})
    args[:start_date] = saved_value(args[:name][:min]).strftime("%d %B %Y") if saved_value(args[:name][:min]).present?
    args[:end_date] = saved_value(args[:name][:max]).strftime("%d %B %Y") if saved_value(args[:name][:max]).present?
    args[:date][:min] = args[:date][:min].strftime("%d %B/%Y") if args[:date][:min].present?
    args[:date][:max] = args[:date][:max].strftime("%d %B/%Y") if args[:date][:max].present?
    args[:name][:max] = set_name(args[:name][:max]) if args[:name][:max].present?
    args[:name][:min] = set_name(args[:name][:min]) if args[:name][:min].present?


    @template.render "partials/form_builder/date_range_field", args: args
  end

  def select2(attribute, options, args={})
    args[:name] = set_name("#{attribute.to_s.singularize}_ids", multiple: true)
    args[:id] ||= args[:name].parameterize
    args[:multiple] ||= true
    args[:errors] ||= get_errors(attribute)
    @template.render "partials/form_builder/multi_select_field", args: args, options: options
  end

  def select2_ajax(attribute, args={})
    args[:name] ||= set_name("#{attribute.to_s.singularize}_ids", multiple: true)
    args[:id] ||= args[:name].parameterize
    args[:multiple] ||= true
    args[:errors] ||= get_errors(attribute)
    @template.render "partials/form_builder/select2_ajax_field", args: args
  end

  def select(attribute, options, args={})
    args[:name] = set_name(attribute, args)
    args[:id] = args[:name].parameterize
    args[:errors] ||= get_errors(attribute)
    @template.render "partials/form_builder/select_field", options: options, args: args, selected: args[:selected] || saved_value(attribute)
  end

  def single_boolean(attribute, args={})
    args[:label] ||= "Yes"
    args[:name] = set_name(attribute, args)
    args[:value] = saved_value(attribute)
    @template.render "partials/form_builder/single_boolean", args: args
  end

  def texteditor(attribute, args={})
    args[:name] = set_name(attribute, args)
    args[:value] ||= saved_value(attribute)
    args[:errors] ||= get_errors(attribute)
    @template.render "partials/form_builder/text_editor_field", args: args
  end

  def blog_editor(attribute, args={})
    args[:name] = set_name(attribute, args)
    args[:value] ||= saved_value(attribute)
    args[:type] = "blog"
    args[:errors] ||= get_errors(attribute)
    @template.render "partials/form_builder/text_editor_field", args: args
  end

  def currency(attribute, args={})
    args[:name] = set_name(attribute, args)
    args[:currency] ||= "Rp"
    args[:value] ||= saved_value(attribute)
    args[:formatted] ||= args[:value]
    args[:id] ||= args[:name].parameterize
    @template.render "partials/form_builder/currency_field", args: args
  end

  def switch_button(attribute, args = {})
    args[:name] ||= set_name(attribute, args)
    args[:value] ||= saved_value(attribute)
    args[:id] ||= args[:name].parameterize
    @template.render "partials/form_builder/switch_button", args: args
  end

  def number(attribute, args = {})
    args[:name] = set_name(attribute, args)
    args[:value] ||= saved_value(attribute)
    args[:id] ||= args[:name].parameterize
    args[:errors] ||= get_errors(attribute)
    @template.render "partials/form_builder/number_field", args: args
  end

  def submit
    @template.render "partials/form_builder/submit_button" do
      super nil, class: 'btn btn-primary'
    end
  end

  def toggle_ajax(attribute, args={})
    label1, label2 = args[:labels].split(',')
    label = saved_value(attribute) ? label1 : label2
    @template.content_tag(:div, {class: 'toggle-ajax',
        data: {action: @template.action_name,
        attribute: attribute, object: @object_name,
        messages: args[:messages], labels: args[:labels]
      }}) do
      @template.check_box_tag(attribute, saved_value(attribute), saved_value(attribute)) +
      (@template.hidden_field_tag(set_name(attribute)[:name], saved_value(attribute)) if @template.action_name != 'edit')+
      @template.label_tag(attribute, label)
    end
  end


  def set_name(attribute, args = {})
    multi = "[]" if args[:multiple]
    attributes = ""
    "#{@object_name}[#{attribute}]#{multi}"
  end

  def saved_value(attribute)
    @object.send(attribute)
  rescue NoMethodError
    nil
  end

  def get_errors(attribute)
    return if @object&.errors.blank?
    @object.errors[attribute.to_sym]
  end
end
