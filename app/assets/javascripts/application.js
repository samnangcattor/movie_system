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
//= require provider.cast
//= require provider.shaka
//= require provider.youtube

window.fbAsyncInit = function() {
  FB.init({
    appId      : "161434647542133",
    xfbml      : true,
    version    : "v2.5"
  });
};

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
