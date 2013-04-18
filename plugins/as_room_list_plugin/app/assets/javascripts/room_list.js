(function(){
  function parse(obj) {
    if(typeof(obj) == 'string') {
      return $.parseJSON(obj);
    } else {
      return obj;
    }
  }

  function incrementUnreadMessageCounter(content) {
    if (content.screen_name != AsakusaSatellite.current.user) {
      var counter = $("#" + content.room.id + " span:first");
      if (counter.text() == "") {
        counter.css("opacity", "1").text("0");
      }
      counter.text("" + (parseInt(counter.text()) + 1));
    }
  }

  function updateLatestMessages(content, room_id) {
    var messages = $("#" + room_id + " .room-list-messages");
    messages.find("div:first").remove();
    var name = $("<span class='user-name'>" + content.name + "</span>");
    var body = $("<span class='message-body'>" + content.body + "</span>");
    messages.append( $("<div></div>").append(name).append(body) );
  }

  $.each(as_room_list_plugin.rooms, function(idx, room_id){
    var channel_id = "as-"+room_id;
    var channel = AsakusaSatellite.pusher.subscribe(channel_id) ||
                  AsakusaSatellite.pusher.channel(channel_id);

    channel.bind('message_create', function(obj){
      var content = parse(obj).content;
      incrementUnreadMessageCounter(content);
      updateLatestMessages(content, room_id);
    });
 
    var visibility = false; 
    $("#" + room_id).bind('click', function(e){
      $(e.target).find(".number").css("opacity", "0").text("");
      $(e.target).find(".room-list-messages").css("display", visibility ? "" : "none");
      visibility = !visibility;
    });
  });
})()

