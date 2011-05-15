require 'governor_background/rails'
require 'governor_background/handler'
require 'governor_background/job_manager'
require 'governor_background/delayed/job'
require 'governor_background/delayed/performer'
require 'governor_background/resque/job'
require 'governor_background/resque/performer'
require 'governor_background/resque/resource'
require 'governor_background/controllers/methods'

begin
  require 'governor_background/resque/performer_with_state'
rescue LoadError
  $stderr.puts 'resque-status gem not installed, GovernorBackground resque jobs unable to report status'
end

module GovernorBackground
  @@blocks = {}
  def self.register(job_name, &block)
    @@blocks[job_name.to_sym] = block
  end
  
  def self.run(job_name, *arguments)
    GovernorBackground::Handler.run_in_background job_name, *arguments
  end
  
  def self.retrieve(job_name)
    @@blocks[job_name.to_sym]
  end
end