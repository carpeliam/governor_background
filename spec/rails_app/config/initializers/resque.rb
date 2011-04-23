require 'resque/job_with_status'
Dir[File.join(Rails.root, 'app', 'jobs', '*.rb')].each { |file| require file }
config = YAML::load(File.open("#{Rails.root}/config/redis.yml"))[Rails.env]
Resque.redis = Redis.new(:host => config['host'], :port => config['port'])
Resque::Status.expire_in = (24 * 60 * 60) # 24hrs in seconds