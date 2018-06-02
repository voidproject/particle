Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace 'api', defaults: {format: :json} do
    resources :posts do
      collection do
      end
    end

    namespace 'gossip', defaults: {format: :json} do
      post 'broadcast'
      post 'connect'
      post 'ping'
      post 'sync_vector_clocks'
      post 'request_message'
      post 'receive_message'
    end
  end


  mount ActionCable.server, at: '/cable'
end
