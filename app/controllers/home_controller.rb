class HomeController < ApplicationController
  def index
    @lead = Lead.new
  end

  def how_it_works
    @section = :hiw
    @lead = Lead.new
  end

  #hidden homepage
  def well_not_ready_yet
  	@lead = Lead.new
  end
end