module GovernorBackground
  # Standard <code>Rails::Engine</code>.
  class Engine < ::Rails::Engine
    config.to_prepare do
      ApplicationController.helper(GovernorBackgroundHelper)
    end
  end
end