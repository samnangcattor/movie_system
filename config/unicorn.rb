# config/unicorn.rb

# Set the working application directory
# working_directory "/path/to/your/app"
working_directory "movie_system"

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "movie_system/tmp/pids/unicorn.pid"

# Path to logs
# stderr_path "/path/to/log/unicorn.log"
# stdout_path "/path/to/log/unicorn.log"
stderr_path "movie_system/log/unicorn.log"
stdout_path "movie_system/log/unicorn.log"

# Unicorn socket
# listen "/tmp/unicorn.[application name].sock"
listen "/tmp/unicorn.movie_system.sock"

# Number of processes
# worker_processes 4
worker_processes 4

# Time-out
timeout 30
