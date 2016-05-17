class OffersController < ApplicationController

  def index
    @section = :program
    @chosen_version = params[:version]
    @offer = Offer.data
  end

end
