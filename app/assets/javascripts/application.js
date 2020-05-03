// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require materialize
//= require materialize-sprockets
//= require materialize-form
//= require best_in_place
//= require_tree .

// @import "materialize";
// @import "https://fonts.googleapis.com/icon?family=Material+Icons";

 M.AutoInit();

// Flash fade
$(function() {
   $('.alert-box').fadeIn('normal', function() {
      $(this).delay(3700).fadeOut();
   });
});

// Carousel function
$(document).ready(function(){
  $('.carousel').carousel();

  $(".dropdown-trigger").dropdown({
    coverTrigger: false
  });
});


  // $(document).ready(function(){
  //   $('#dates').hide();
  //   $('.custom_radio_button')[0].change(function() {
  //     console.log("hello world");
  //         if (evt.target.value === "0") {
  //             $('#dates').show();
  //         } else {
  //             $('#dates').hide();
  //         }
  //     })
  // });



$('#dates').hide();
$('input[name="set_start"]').on('change', function(evt) {

   if (evt.target.value === "0") {
      $('#dates').show();
   } else {
      $('#dates').hide();
   }
})



// Best in place functionality
$(document).ready(function() {
  jQuery(".best_in_place").best_in_place();
});

// Search submit on enter
$(document).ready(function() {
  function submitForm() {
    document.getElementById("search").submit();
  }
  document.onkeydown = function () {
    if (window.event.keyCode == '13') {
        submitForm();
    }
  }
});



  // Or with jQuery

  $(document).ready(function(){
    $('.tabs').tabs();
  });

    document.addEventListener('DOMContentLoaded', function() {
    var elems = document.querySelectorAll('.collapsible');
    var instances = M.Collapsible.init(elems, options);
  });



// Search submit on enter
$(document).ready(function() {
  function submitForm() {
    document.getElementById("search").submit();
  }
  document.onkeydown = function () {
    if (window.event.keyCode == '13') {
        submitForm();
    }
  }
});


document.addEventListener('DOMContentLoaded', function() {
    var elems = document.querySelectorAll('.dropdown-trigger');
    var instances = M.Dropdown.init(elems, options);
  });


//J Query



//   $(document).ready(function(){
//     $('input[name="set_start"]').on('change', function(evt) {
//    if (evt.target.value === "0") {
//       $('#dates').show();
//    } else {
//       $('#dates').hide();
//    }
// })
//   });




  $( document ).ready(function() {
    console.log( "ready!" );
});



