class HomeController < ApplicationController
  def index
    @lead = Lead.new
  end

  def faq
    @section = :faq
    @lead = Lead.new
  end

  def specs
    @section = :specs
    @lead = Lead.new
  end

  def service
    @section = :service
  end

  def program
    @section = :program
  end

  def mission
    @section = :mission
  end

end