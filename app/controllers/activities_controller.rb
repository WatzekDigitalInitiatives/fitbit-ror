class ActivitiesController < ApplicationController

  def push
    if params[:verify] == "56a0073dd7288f9f4f70e78a2ee4e753a75db23859c5a0980cdb1022b1b1eb78"
      head :no_content
      # raise ActionController::RoutingError.new('Verfied')
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end
