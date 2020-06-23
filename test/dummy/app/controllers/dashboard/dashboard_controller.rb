module Dashboard
  class DashboardController < ::ApplicationController
  layout 'dashboard'
    # before_action :authenticate_user!

    protected

    def self.attached_files(object, files = [])
      files.each do |file|
        define_method("#{object}_#{file}") do
          ActiveStorage::Blob.where(id: params["#{object}[#{file}_ids]"]&.split(','))
        end
      end
    end
  end
end
