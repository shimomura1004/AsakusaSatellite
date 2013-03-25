var notificationArea = (function(){
    function closeSidebar() {
        resizeSidebar(0, 0);
    }
    function openSidebar() {
        var width = sidebarInfo.width;
        var distance = (document.body.clientWidth - (mainWidth + widthMargin)) / 2 - width;
        if (distance > 0) {
            distance = 0;
        }
        resizeSidebar(distance, width);
    }
    function resizeSidebar(distance, width){
        main.css({
            "transform" : "translate("+distance+"px, 0px)",
            "-webkit-transform" : "translate("+distance+"px, 0px)",
            "-moz-transform" : "translate("+distance+"px, 0px)",
        });
        notificationArea.css("width", ""+width+"px");
    }

    var sidebarInfo = $.LocalStorage.get("sidebarInfo", {
        opened : true,
        width  : 400,
    });
    var mainWidth = 720;
    var widthMargin = 120;

    var notificationArea = $("#notification_area");
    var main = $(".main");
    var button = $("#open_button span");

    button.bind("click", function(){
        if (sidebarInfo.opened) {
            closeSidebar();
            button.text("OPEN");
            sidebarInfo.opened = false;
        } else {
            openSidebar();
            button.text("CLOSE");
            sidebarInfo.opened = true;
        }
        $.LocalStorage.set("sidebarInfo", sidebarInfo);
    });
    if (sidebarInfo.opened) {
        openSidebar();
        button.text("CLOSE");
    }

    var pos_x = undefined;
    $("body").bind("mouseup", function(){
        if (pos_x != undefined) {
           pos_x = undefined;
           $.LocalStorage.set("sidebarInfo", sidebarInfo);
$("#notification_area").css({
   "transition" : "width 0.1s ease-out",
   "-webkit-transition" : "width 0.1s ease-out",
   "-moz-transition" : "width 0.1s ease-out",
});
$(".main").css({
   "transition" : "transform 0.1s ease-out",
   "-webkit-transition" : "-webkit-transform 0.1s ease-out",
   "-moz-transition" : "-moz-transform 0.1s ease-out",
});
        }
    }).bind("mousemove", function(e){
        if (pos_x != undefined) {
            sidebarInfo.width += pos_x - e.screenX;
            pos_x = e.screenX;
            openSidebar();
        }
    });
    $("#notification_area #grip").bind("mousedown", function(e){
        e.preventDefault();
        pos_x = e.screenX;
$("#notification_area").css({
   "transition" : "none",
   "-webkit-transition" : "none",
   "-moz-transition" : "none",
});
$(".main").css({
   "transition" : "none",
   "-webkit-transition" : "none",
   "-moz-transition" : "none",
});
    });
})();
