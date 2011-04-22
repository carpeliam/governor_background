require 'governor_background/handler'
require 'governor_background/job_manager'
require 'governor_background/delayed/job'
require 'governor_background/delayed/job_state'
require 'governor_background/resque/job'

background = Governor::Plugin.new('background')

background.register_model_callback do |base|
  module InstanceMethods
    private
    def run_in_background(method)
      GovernorBackground::Handler.run_in_background self, method
    end
  end
  base.send :include, InstanceMethods
end

Governor::PluginManager.register background