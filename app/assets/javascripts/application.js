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
//= require popover
//= require videojs
//= require jquery.soulmate
//= require facebook_page
//= require fuckadblock

window.fbAsyncInit = function() {
  FB.init({
    appId      : "161434647542133",
    xfbml      : true,
    version    : "v2.5"
  });
};

var ready = function(){
  var render, select;

  render = function(term, data, type) {
    return term;
  }

  select = function(term, data, type){
    $("#search").val(term);

    $("ul#soulmate").hide();
    return window.location.href = data.link;
  }

  $("#search").soulmate({
    url: "/autocomplete/search",
    types: ["movies"],
    renderCallback : render,
    selectCallback : select,
    minQueryLength : 2,
    maxResults     : 5
  })
}

$(document).ready(ready);

$(document).on("page:load", ready);

$(document).ready(function() {
  function adBlockDetected() {
    alert("AdBlock has been found in your browser, please disable it to watch movie");
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
