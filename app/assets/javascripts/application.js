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
//= require jquery.browser
//= require custom

window.fbAsyncInit = function() {
  FB.init({
    appId      : "161434647542133",
    xfbml      : true,
    version    : "v2.5"
  });
};

$(function(){
  var data_default = $("#player").data("default");
  var data_hd = $("#player").data("hd");
  var data_sub = $("#player").data("sub");
  var data_url = $("#player").data("url");

  if (data_url == undefined){
    if (data_hd != "") {
      jwplayer("player").setup({
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
        width: '100%',
        aspectratio: '16:9',
        tracks: [{
          file: data_sub,
          label: "English",
          kind: "captions",
          "default": true
        }]
      });
    }else {
      jwplayer("player").setup({
        sources: [{
          file: data_default,
          label: "360p SD",
          "default": "true",
          type: "mp4"
        }],
        width: '100%',
        aspectratio: '16:9',
        tracks: [{
          file: data_sub,
          label: "English",
          kind: "captions",
          "default": true
        }]
      });
    }
  }
  else
  {
    jwplayer("player").setup({
      sources: [{
        file: data_url,
        label: "360p SD",
        "default": "true",
        type: "mp4"
      }],
      width: '100%',
      aspectratio: '16:9',
      tracks: [{
        file: data_sub,
        label: "English",
        kind: "captions",
        "default": true
      }]
    });
  }
});

$(document).ready(function() {
  function adBlockDetected() {
    if($("#instructions").length > 0){
      $("#instructions").html("Please don't block advertise on moviehdkh");
    }
  }

  if(typeof fuckAdBlock === "undefined") {
      adBlockDetected();
  } else {
    fuckAdBlock.on(true, adBlockDetected).onNotDetected(adBlockNotDetected);
  }

  fuckAdBlock.setOptions("checkOnLoad", false);

  fuckAdBlock.setOptions({
    checkOnLoad: false,
    resetOnEnd: false
  });
});
