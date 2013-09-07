class DesktopnotificationListener < AsakusaSatellite::Hook::Listener
  js_path = plugin_root + "app/assets/javascripts/"

  render_on :account_setting_item, :partial => "desktopnotification_setting"
  render_on :script_in_account_setting, :jsfile => js_path + "desktopnotification.js"
  render_on :script_in_account_setting, :jsfile => js_path + "desktopnotification_setting.js"
  render_on :script_in_chat_room, :jsfile => js_path + "desktopnotification.js"
  render_on :script_in_chat_room, :jsfile => js_path + "desktopnotification_notify.js"
end
