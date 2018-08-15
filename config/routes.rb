Rails.application.routes.draw do
  require "sidekiq/web"

  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount Facebook::Messenger::Server, at: 'bot'

  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                  sessions: 'users/sessions'
                 }

  root to: 'pages#home'
end
