class HomeController < ApplicationController
  def index
    @lead = Lead.new
  end

  def faq
    @section = :faq
    @lead = Lead.new
  end

end