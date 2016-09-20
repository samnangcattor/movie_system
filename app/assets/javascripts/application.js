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
//= require polyfills.base64
//= require polyfills.promise
//= require polyfills.vttcue
//= require polyfills.vttrenderer
//= require provider.cast
//= require provider.caterpillar
//= require provider.flash
//= require provider.html5
//= require provider.shaka
//= require provider.youtube
//= require vttparser
//= require jw-logo-bar

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
  var primaryCookie = "html5";
  var data_default = $("#extensive").data("default");
  var data_hd = $("#extensive").data("hd");
  var data_medium = $("#extensive").data("medium");
  var data_sub = $("#extensive").data("sub");
  var extensive_player = $("#extensive");
  var color_inactive = "#f1c40f";
  var color_active = "#f39c12";
  var color_background = "#232221";
  var quality = [];


  if (data_hd != "") {
    quality = [{
        file: data_hd,
        type: "mp4",
        label: "720"
      },{
        file: data_medium,
        type: "mp4",
        label: "480"
      }, {
        file: data_default,
        type: "mp4",
        default: true,
        label: "360"
    }];
  } else if (data_medium != "") {
    quality = [{
        file: data_medium,
        type: "mp4",
        label: "480"
      },{
        file: data_default,
        type: "mp4",
        label: "360"
      }, {
        file: data_default,
        type: "mp4",
        default: true,
        label: "default"
    }];
  } else {
    quality = [{
        file: data_default,
        type: "mp4",
        default: true,
        label: "360"
    }];
  }

  $(document).on("click", "#add-genre", function(e){
    var conceptName = $("#movie-genre").find(":selected").text();
    $("#text-genre").append(conceptName + "\n");
  });

  jwplayer("extensive").setup({
    playlist: [{
    image: "https://moviehdkh.com/assets/logo-a89ac077ebeb6e980852ad282214a68f0cf5966f43a863588b2bdad9749bc7c4.png",
    title: "your play button title",
    sources: quality}],
    height: 508,
    primary: "html5",
    autostart: true,
    "sharing": {
      "sites": ["facebook","twitter"]
    },
    controls: true,
    skin : {
      name: "flat",
      active: color_active,
      inactive: color_inactive,
      background: color_background
    }
  });
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
