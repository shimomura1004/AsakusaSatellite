class RoomListPluginListener < AsakusaSatellite::Hook::Listener
  render_on :notification_area_section, :partial => "room_list_section"
end

