require 'rails/generators/named_base'
require File.expand_path('helpers.rb', __dir__)

module FormBuilder
  module Generators
    class FormBuilderGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      include FormBuilder::Generators::Helpers
      source_root File.expand_path('templates', __dir__)

      class_option :scope, type: :array, default: []
      argument :fields, type: :array, default: []

      def copy_files
        template 'views/form.erb', "app/views/dashboard/#{plural_name}/_form.html.haml"
        template 'views/new.erb', "app/views/dashboard/#{plural_name}/new.html.haml"
        template 'views/index.erb', "app/views/dashboard/#{plural_name}/index.html.haml"
        template 'views/edit.erb', "app/views/dashboard/#{plural_name}/edit.html.haml"
        template 'controller.erb', "app/controllers/dashboard/#{plural_name}_controller.rb"
        template 'migration.erb', "db/migrate/#{timestamp}_create_#{singular_name.underscore}.rb"
        template 'model.erb', "app/models/#{singular_name}.rb"
      end

      def inject_routes
        inject_into_file 'config/routes.rb',"\n\t\tresources :#{plural_name}", after: 'namespace :dashboard do'
      end
    end
  end
end
