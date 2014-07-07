LunchPicker::Application.routes.draw do
  resources :elections

  resources :ballot_options
  resources :history
  resources :voter_registry
  resources :group_members
  
  resource :vote do
    delete :cancel_user_votes
  end
  
  root to:"elections#show"
end
