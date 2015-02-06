class Admin::BaseController < ApplicationController
  http_basic_authenticate_with name: ENV['ADMIN_LOGIN'], password: ENV['ADMIN_PWD']

  layout 'admin'
end