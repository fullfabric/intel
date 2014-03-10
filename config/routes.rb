Intel::Engine.routes.draw do

  match "classes/:id" => "app/classes#show"

  match "classes/:id/states/weekly" => "classes/states#weekly"
  match "classes/:id/states"        => "classes/states#index"

  match "classes/:id/dimensions/:dimension" => "classes/dimensions#index"

end
