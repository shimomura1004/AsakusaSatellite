class DirectMessagePluginListener < AsakusaSatellite::Hook::Listener
  def global_footer(context)
    controller = context[:request][:controller]
    action     = context[:request][:action]

    case {:controller => controller, :action => action}
    when {:controller => "chat", :action => "room"}
      "<script>#{read_file "app/assets/javascripts/direct_message.js"}</script>"
    end
  end
end

