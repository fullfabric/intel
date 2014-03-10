Rails.application.routes.draw do
  mount Intel::Engine => "/intel"
end
