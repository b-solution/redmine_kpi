# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
resources :kpi_settings
match '/kpi', to: 'kpi#index', via: [:get]
match '/kpi/:action', controller: 'kpi', via: [:get, :post]