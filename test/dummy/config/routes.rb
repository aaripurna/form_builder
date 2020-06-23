Rails.application.routes.draw do
	namespace :dashboard do
		resources :blogs
	end
  mount FormBuilder::Engine => "/form_builder"
end
