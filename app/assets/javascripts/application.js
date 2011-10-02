// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

function showHideEditLink(selector){
	$(selector).mouseenter(function (){		
		$(this).find('small').show();	
	}).mouseleave(function(){
		$(this).find('small').hide();	
	});
}

$(document).ready(function () {
	// Alert
	$(".alert-message").alert();
	$(".alert-message").delay(2000).fadeOut('slow');

	//Edit links
	$("article h2 small").hide();
	showHideEditLink("article h2")
	$("h1 small").hide();
	showHideEditLink("h1");
})
