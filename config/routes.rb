Intel::Engine.routes.draw do

  scope module: :v1, constraints: RouterVersioning.new( version: 1, default: true ), defaults: { format: 'json' } do

    match "classes/:id" => "app/classes#show"

    match "classes/:id/states/weekly" => "classes/states#weekly"
    match "classes/:id/states"        => "classes/states#index"

    match "classes/:id/dimensions/:dimension" => "classes/dimensions#index"

  end

end