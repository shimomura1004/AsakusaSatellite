class NotificationAreaPluginListener < AsakusaSatellite::Hook::Listener
  def global_footer(context)
    controller = context[:request][:controller]
    action     = context[:request][:action]

    haml = context[:controller].send(:render_to_string,
                                     {:locals => context, :partial => "notification_area"})
    script =
      case {:controller => controller, :action => action}
      when {:controller => "chat", :action => "room"}
        "<script>#{read_file "app/assets/javascripts/notification_area.js"}</script>"
      end

    haml + script
  end

  def global_header(context)
    controller = context[:request][:controller]
    action     = context[:request][:action]

    case {:controller => controller, :action => action}
    when {:controller => "chat", :action => "room"}
      "<style>#{read_file "app/assets/stylesheets/notification_area.css"}</style>"
    end
  end
end
