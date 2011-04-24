module GovernorBackgroundHelper
  def background_status
    if flash[:governor_background]
      content_tag :div, :class => 'background' do
        flash[:governor_background].each do |(status, message)|
          concat(content_tag :div, message, :class => status)
        end
      end
    end
  end
end