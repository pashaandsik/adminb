env               = ENV["RAILS_ENV"] || "production"
project           = "binomo"
domain            = "#{project}.com"
app_path          = "/home/#{project}/#{domain}"
current_path      = "#{app_path}/current"
shared_path       = "#{app_path}/shared"
log_path          = "#{shared_path}/log"
pids_path         = "#{shared_path}/tmp/pids"

preload_app       true
timeout           30
working_directory current_path
pid               "#{pids_path}/unicorn.pid"
stderr_path       "#{log_path}/#{project}.unicorn.stderr.log"
stdout_path       "#{log_path}/#{project}.unicorn.stdout.log"
listen            "/tmp/#{project}.unicorn.sock", :backlog => 1024, tcp_nodelay: true

if env == "production"
  worker_processes 8
else
  worker_processes 1
end

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{current_path}/Gemfile"
end

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection

    if env == "production"
      filepath = "#{log_path}/#{env}.#{worker.nr}.log"
      Rails.logger = Logger.new(filepath, File::WRONLY | File::APPEND)
      ActiveSupport::LogSubscriber.logger = Rails.logger
      ActionController::Base.logger = Rails.logger
      ActiveRecord::Base.logger = Rails.logger
      ActionMailer::Base.logger = Rails.logger
      ActionView::Base.logger = Rails.logger
    end
  end
end
