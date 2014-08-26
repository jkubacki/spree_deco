Spree::Core::Engine.routes.append do
  scope module: 'spree' do
    scope module: 'admin' do
      get 'deco' => 'deco#index', as: 'admin_deco'
      get 'deco/edit' => 'deco#edit', as: 'admin_deco_edit'
      post 'deco/update' => 'deco#update', as: 'admin_deco_update'
    end
  end
end