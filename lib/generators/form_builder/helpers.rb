require 'yaml'

module FormBuilder
  module Generators
    module Helpers
      def available_fields
        @available_fields ||= YAML.load_file(File.expand_path('utils/fields.yaml', __dir__))
      end

      def timestamp
        Time.now.strftime("%Y%m%d%H%M%S")
      end

      def extract_params_from_fields
        singular_parameters = []
        multiple_parameters = []

        fields.each do |field|
          field_name, type, argument = field.split(':')
          row = available_fields[type]
          if row['multiple'].present? || ['array', 'multiple'].include?(argument)
            multiple_parameters.push("#{field_name}: []")
          else
            singular_parameters.push(":#{field_name}")
          end
        end
        singular_parameters.concat(multiple_parameters)
      end

      def attached_multiple_files
        fields.filter do |field|
          field_name, type, argument = field.split(':')
          row = available_fields[type]
          row['form'] == 'galleries' || ['galleries'].include?(type)
        end.map { |field| field.split(':')[0]}
      end

      def attached_singular_files
        fields.filter do |field|
          field_name, type, argument = field.split(':')
          row = available_fields[type]
          ['image', 'file'].include?(row['form']) || ['image', 'file'].include?(type)
        end.map { |field| field.split(':')[0]}
      end

      def database_relations
        fields.filter do |field|
          field_name, type, argument = field.split(':')
          row = available_fields[type]
          ['references'].include?(row['field']) || ['references'].include?(type)
        end.map { |field| field.split(':')[0]}
      end

      def form_input_field
        fields.map do |field|
          name, type, argument = field.split(':')
          label = name
          row = available_fields[type]
          if row['field'] == 'references' || type == 'references'
            name = "#{name}_id"
          end
          { name: name, input: row['form'], label: label }
        end
      end

      def index_table_list_item
        fields.map do |field|
          name, type, argument = field.split(':')
          name
        end
      end

      def migration_attributes
        fields.map do |field|
          name, type, argument = field.split(':')
          options = []
          row = available_fields[type]
          next if ( ['file', 'image', 'galleries'].include?(argument) || row['field'].blank?)

          if (type == 'references' || row['field'] == 'references') && argument&.include?('polymorphic')
            options << "polymorphic: true"

          elsif type == 'references' || row['field'] == 'references'
            options << "index: true"
            options << "foreign_key: true"

          elsif argument&.include? ('index')
            options << "index: true"
          end

          options << "array: true" if (row['multiple'].present? || ['multiple', 'array'].include?(argument))

          if argument.present?
            options << "unique: true" if (argument.include?('unique') && !(type == 'references' || row['field'] == 'references'))
          end
          { name: name, field: row['field'], options: options }
        end.compact
      end
    end
  end
end
