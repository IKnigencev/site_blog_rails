class ApplicationController < ActionController::Base
  ##
  # Рендер 404 страницы
  def not_found
    raise ActionController::RoutingError, "Not Found"
  end
end
