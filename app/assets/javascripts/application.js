// This is a manifest file that"ll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin"s vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It"s not advisable to add code directly here, but if you do, it"ll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.turbolinks
//= require bootstrap-sprockets
//= require facebook_page
//= require fuckadblock
//= require video
//= require video-quality-selector
//= require blazy.min

  window.fbAsyncInit = function() {
    FB.init({
      appId      : '105132389905258',
      xfbml      : true,
      version    : 'v2.6'
    });
  };

  (function(d, s, id){
     var js, fjs = d.getElementsByTagName(s)[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement(s); js.id = id;
     js.src = "//connect.facebook.net/en_US/sdk.js";
     fjs.parentNode.insertBefore(js, fjs);
   }(document, 'script', 'facebook-jssdk'));

$(function() {
    var bLazy = new Blazy({
        breakpoints: [{
      width: 420 // Max-width
          , src: 'data-src-small'
  }]
      , success: function(element){
      setTimeout(function(){
    // We want to remove the loader gif now.
    // First we find the parent container
    // then we remove the "loading" class which holds the loader image
    var parent = element.parentNode;
    parent.className = parent.className.replace(/\bloading\b/,'');
      }, 200);
        }
   });

});

$(window).bind("load", function() {
    var timeout = setTimeout(function() {
        $("img.lazy").trigger("sporty")
    }, 5000);
});

$(function(){
  var primaryCookie = "html5";
  var skinURL = "flat";
  var data_default = $("#extensive").data("default");
  var data_hd = $("#extensive").data("hd");
  var data_medium = $("#extensive").data("medium");
  var data_sub = $("#extensive").data("sub");
  var extensive_player = $("#extensive");

    if (extensive_player.length > 0){
     var cookies = document.cookie.split(";");
     for (i=0; i < cookies.length; i++) {
       var x = cookies[i].substr(0, cookies[i].indexOf("="));
       var y = cookies[i].substr(cookies[i].indexOf("=") + 1);
       x = x.replace(/^\s+|\s+$/g,"");
       if (x == "primaryCookie") {
           primaryCookie = y;
       } else if (x == "skinURL") {
           skinURL = y;
       }
    }

     if (data_hd != ""){
       jwplayer("extensive").setup({
         sources: [{
           file: data_hd,
           label: "720",
           type: "mp4"
         },{
           file: data_medium,
           label: "480",
           type: "mp4"
         },{
           file: data_default,
           label: "360",
           "default": true,
           type: "mp4"
         }],
         width: "100%",
         aspectratio: "16:9",
         skin: skinURL,
         tracks: [{
           file: data_sub,
           label: "English",
           kind: "captions",
           "default": true
         }],
         primary: primaryCookie
       });
     }else if (data_medium != ""){
       jwplayer("extensive").setup({
         sources: [{
           file: data_medium,
           label: "480",
           type: "mp4"
         },{
           file: data_default,
           label: "360",
           type: "mp4"
         },{
           file: data_default,
           label: "Default",
           "default": true,
           type: "mp4"
         }],
         width: "100%",
         aspectratio: "16:9",
         skin: skinURL,
         tracks: [{
           file: data_sub,
           label: "English",
           kind: "captions",
           "default": "true"
         }],
         primary: primaryCookie
       });
     }else {
      jwplayer("extensive").setup({
         sources: [{
          file: data_default,
          label: "360p",
           "default": "true",
           type: "mp4"
         }],
        width: "100%",
        aspectratio: "16:9",
        skin: skinURL,
        tracks: [{
          file: data_sub,
          label: "English",
          kind: "captions",
          "default": true
        }],
        primary: primaryCookie
      });
    }
  }
 });

$(function(){
  function adBlockDetected() {
    if($("#instructions").length > 0){
      $("#instructions").html("Please don't block advertise on moviehdkh");
    }
  }

  if(typeof fuckAdBlock === "undefined") {
    adBlockDetected();
  } else {
    fuckAdBlock.on(true, adBlockDetected).onNotDetected();
  }

  fuckAdBlock.setOptions("checkOnLoad", false);

  fuckAdBlock.setOptions({
    checkOnLoad: false,
    resetOnEnd: false
  });
});
