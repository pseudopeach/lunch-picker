LunchPicker::Application.routes.draw do
  resource :election do
    get :results
  end
  resources :ballot_options
  resources :history
  resources :voter_regestry
  resources :group_members
  
  resource :vote do
    delete :cancel_user_votes
  end
  
  root to:"elections#show"
end
