background = Governor::Plugin.new('background')

background.register_model_callback do |base|
  module InstanceMethods
    def run_in_background
      puts 'about to yield'
      yield
      puts 'done yielding'
    end
  end
  base.send :include, InstanceMethods
end

Governor::PluginManager.register background