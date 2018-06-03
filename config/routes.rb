Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace 'api', defaults: {format: :json} do
    post 'add' => 'posts#add'
    post 'get_home_feed' => 'posts#get_home_feed'
    post 'get_message' => 'posts#get_message'
    post 'get_messages_by_root' => 'posts#get_messages_by_root'
    post 'get_channels' => 'posts#get_channels'
    post 'get_channel_messages' => 'posts#get_channel_messages'
    post 'add_user' => 'users#add_user'
    post 'get_users' => 'users#get_users'
    post 'get_user' => 'users#get_user'
    post 'get_user_messages' => 'users#get_user_messages'
    post 'has_follow' => 'users#has_follow'

    resources :posts do
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
