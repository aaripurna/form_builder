require 'rails/generators/base'

module FormBuilder
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def copy_views
        copy_file "dashboard_layout.erb", "app/views/layouts/dashboard.html.haml"
        copy_file "partial_views/breadcrumb.erb", "app/views/partials/dashboard/_breadcrumb.html.haml"
        copy_file "partial_views/dashboard_header_form.erb", "app/views/partials/dashboard/_dashboard_header_form.html.haml"
        copy_file "partial_views/dashboard_header_index.erb", "app/views/partials/dashboard/_dashboard_header_index.html.haml"
      end

      def copy_helper
        if Kernel.const_defined?('DashboardHelper')
          inject_into_file Rails.root.join('app/helpers/dashboard_helper.rb'), "\tinclude FormBuilder", after: 'module DashboardHelper'
        else
          copy_file 'dashboard_helper.erb', 'app/helpers/dashboard_helper.rb'
        end
      end

      def copy_dashboard_controller
        copy_file "dashboard_controller.erb", "app/controllers/dashboard/dashboard_controller.rb"
      end

      def inject_routes
        inject_into_file Rails.root.join('config/routes.rb'),"\n\tnamespace :dashboard do\n\tend", after: 'Rails.application.routes.draw do'
      end
    end
  end
end
