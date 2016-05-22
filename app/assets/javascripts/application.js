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
//= require jwplayer
//= require jwplayer.html5

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

$(function(){
  var loader = $("#loader");
  var duration = $("#duration");
  var sec = 48;
  if (loader.length >0){
    timer = setInterval(function(){
      duration.html(--sec+"s");
      if (sec == 0) {
        clearInterval(timer);
        location.reload();
      }
    }, 1000);
  }
});


$(function(){
  var primaryCookie = "html5";
  var skinURL = "/skins/yellow.xml";
  var data_default = $("#extensive").data("default");
  var data_hd = $("#extensive").data("hd");
  var data_super_hd = $("#extensive").data("super_hd");
  var data_sub = $("#extensive").data("sub");

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

  if (data_super_hd != null){
    jwplayer("extensive").setup({
      sources: [{
        file: data_super_hd,
        label: "1080 HD",
        type: "mp4"
      },{
        file: data_hd,
        label: "720p HD",
        type: "mp4"
      },{
        file: data_default,
        label: "360p SD",
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
  }else if (data_hd != ""){
    jwplayer("extensive").setup({
      sources: [{
        file: data_hd,
        label: "720p HD",
        type: "mp4"
      },{
        file: data_default,
        label: "360p SD",
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
        "default": "true"
      }],
      primary: primaryCookie
    });
  }else {
    jwplayer("extensive").setup({
      sources: [{
        file: data_default,
        label: "360p SD",
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
