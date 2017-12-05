Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable do
      post :mark_as_best
    end
  end

  root to: "questions#index"
end
