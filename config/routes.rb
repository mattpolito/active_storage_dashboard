# frozen_string_literal: true

ActiveStorageDashboard::Engine.routes.draw do
  root to: 'dashboard#index'

  get 'dashboard/content_types', to: 'dashboard#content_types', as: :dashboard_content_types
  get 'dashboard/stats/:stat', to: 'dashboard#stat', as: :dashboard_stat
  get 'dashboard/storage_usage', to: 'dashboard#storage_usage', as: :dashboard_storage_usage

  resources :blobs, only: [:index, :show], path: 'blobs' do
    member do
      get 'download(/:disposition)', action: :download, as: :download
    end
  end
  
  resources :attachments, only: [:index, :show], path: 'attachments' do
    member do
      get 'download(/:disposition)', action: :download, as: :download
    end
  end
  
  resources :variant_records, only: [:index, :show], path: 'variant_records'
end 