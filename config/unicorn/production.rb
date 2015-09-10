rails_env = ENV['RAILS_ENV'] || 'production'

worker_processes rails_env == "production" ? 2 : 1

APP_PATH = rails_env == "production" ? '/srv/apps/rails/current' : '/use/railsgirls'

working_directory "#{APP_PATH}"

listen "#{APP_PATH}/tmp/sockets/app.sock.0", :backlog => 64

timeout 60

pid "#{APP_PATH}/tmp/pids/unicorn.pid"

stderr_path "#{APP_PATH}/tmp/unicorn.stderr.log"
stdout_path "#{APP_PATH}/tmp/unicorn.stdout.log"

preload_app false
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

before_fork do |server, worker|

  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end

  sleep 4
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.establish_connection
end
