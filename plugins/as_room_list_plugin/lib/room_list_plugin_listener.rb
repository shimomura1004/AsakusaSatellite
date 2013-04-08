class RoomListPluginListener < AsakusaSatellite::Hook::Listener
  render_on :notification_area_section, :partial => "room_list_section"

  def in_chatroom_controller(context)
    context[:controller].instance_eval do
      @rooms = Room.all_live(current_user).map do |room|
        {
          :room => room,
          :messages => Message.where(:room_id => room.id).limit(3).desc(:_id)
        }
      end
    end
  end

  def global_header(context)
    controller = context[:request][:controller]
    action     = context[:request][:action]

    case {:controller => controller, :action => action}
    when {:controller => "chat", :action => "room"}
      "<style>#{read_file "app/assets/stylesheets/room_list.css"}</style>"
    end
  end

  def global_footer(context)
    controller = context[:request][:controller]
    action     = context[:request][:action]

    case {:controller => controller, :action => action}
    when {:controller => "chat", :action => "room"}
      "<script>#{read_file "app/assets/javascripts/room_list.js"}</script>"
    end
  end
end
