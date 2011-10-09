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

function showFormNewUserStory(selector){
	$(selector).click(function (e){
		e.preventDefault();
		$(this).hide();
		$(this).parent().find("form.new_userstory").show();
		$("#userstory_content").focus();
	});
}
function hideFormNewUserStory(selector){
	$(selector).click(function (e){
		e.preventDefault();
		$(this).parent().hide();
		$(this).parent().parent().find("a.show_form_new_userstory").show();
	});
}

$(document).ready(function () {
	// Alert
	$(".alert-message").alert();
	$(".alert-message").delay(2000).fadeOut('slow');

	//Edit links
	$("article h3 small").hide();
	showHideEditLink("article h3")
	$("h1 small").hide();
	showHideEditLink("h1");
	
	//Show form link
	$("a.show_form_new_userstory").hide();
	if (!$("div.clearfix").hasClass("error")) {
		$("form.new_userstory").hide();
		$("a.show_form_new_userstory").show();
	}
	showFormNewUserStory("a.show_form_new_userstory");
	hideFormNewUserStory("a.hide_form_new_userstory");
})
