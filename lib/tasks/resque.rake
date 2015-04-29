require 'resque/tasks'

namespace :resque do
  task :setup => :environment do
    Resque.after_fork do |job|
      ActiveRecord::Base.establish_connection
    end
  end
end