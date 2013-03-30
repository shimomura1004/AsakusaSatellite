(function(){
    $(".online-user").map(function(idx, user){
        var id = user.id.replace("online_status_user_","");
        var info = $(user).find(".info");

        if (AsakusaSatellite.current.user != info.find("span:first").text()) {
            var atag = $("<a href='/user/direct_message?user="+id+"' target='_blank'></a>");
            atag.append( $(info).find("span")[1] );
            info.append(atag);
        }
    });
})()
