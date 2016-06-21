env               = ENV["RAILS_ENV"] || "development"
project           = "binomo"
domain            = "#{project}.dev"
app_path          = "/srv/#{project}/#{domain}"
log_path          = "#{app_path}/log"
pids_path         = "#{app_path}/tmp/pids"

preload_app       true
timeout           30
working_directory app_path
pid               "#{pids_path}/unicorn.pid"
stderr_path       "#{log_path}/#{project}.unicorn.stderr.log"
stdout_path       "#{log_path}/#{project}.unicorn.stdout.log"
listen            "#{pids_path}/#{project}.unicorn.sock", backlog: 1024, tcp_nodelay: true

if env == "production"
  worker_processes 8
else
  worker_processes 1
end

before_exec do |_server|
  ENV['BUNDLE_GEMFILE'] = "#{app_path}/Gemfile"
end

before_fork do |server, _worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |_server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
