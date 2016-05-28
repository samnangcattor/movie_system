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
//= require video.dev
//= require video-js-resolutions

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
  var sec = 75;
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
