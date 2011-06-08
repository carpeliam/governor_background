module GovernorBackground
  autoload :Handler, 'governor_background/handler'
  autoload :JobManager, 'governor_background/job_manager'
  module Delayed
    autoload :Job, 'governor_background/delayed/job'
    autoload :Performer, 'governor_background/delayed/performer'
  end
  module Resque
    autoload :Job, 'governor_background/resque/job'
    autoload :Resource, 'governor_background/resque/resource'
    autoload :Performer, 'governor_background/resque/performer'
    autoload :PerformerWithState, 'governor_background/resque/performer_with_state'
  end
  module Controllers
    autoload :Methods, 'governor_background/controllers/methods'
  end
  
  @@blocks = {}
  # Registers this job to be run later. Must be called upon application
  # initialization.
  #
  # Example:
  #
  #     GovernorBackground.register('twitter_post') do |content|
  #       Twitter.update(content)
  #     end
  #
  # Job names must be globally unique. It's recommended that you preface the
  # job name with the name of the containing plugin.
  def self.register(job_name, &block)
    @@blocks[job_name.to_s] = block
  end
  
  # Runs the job with the supplied arguments.
  #
  # Example:
  #
  #     GovernorBackground.run('twitter_post', 'I am so awesome')
  #
  # +job_name+ refers to the identifier for a previously registered job.
  def self.run(job_name, *arguments)
    GovernorBackground::Handler.run_in_background job_name, *arguments
  end
  
  # Retrieves the block for a +job_name+, which must have been previously
  # registered. This will return a Proc object if the job is found, or +nil+
  # if no job was registered under this name.
  def self.retrieve(job_name)
    @@blocks[job_name.to_s]
  end
end

require 'governor_background/rails'