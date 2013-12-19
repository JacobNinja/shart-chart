ShartChart::Application.routes.draw do

  root to: 'application#index'
  get :graph, controller: 'application'

end
