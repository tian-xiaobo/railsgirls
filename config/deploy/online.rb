set :branch, 'master'
#ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
server 'root@rails-girls-peterwillcn.myalauda.cn', roles: %w[web app db], port: 58131, primary: true #, sidekiq: true, whenever: true
