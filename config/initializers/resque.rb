Resque.redis = Redis.new(host: ENV.fetch('REDIS_HOST', 'site_blog_rails_redis_1'), port: ENV.fetch('REDIS_PORT', 6379), db: 3)
Resque.logger.level = Logger::DEBUG
Resque.logger = Logger.new(Rails.root.join('log', "#{Rails.env}_resque.log"))
