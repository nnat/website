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
  end

  def services
    @section = :services
  end

  def program
    @section = :program
  end

  def mission
    @section = :mission
  end

end