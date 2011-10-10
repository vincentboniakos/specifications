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
		$(this).parent().find("form.new_userstory").find("textarea").focus();
	});
}
function hideFormNewUserStory(selector){
	$(selector).click(function (e){
		e.preventDefault();
		$(this).parent().hide();
		$(this).parent().parent().find("a.show_form_new_userstory").show();
	});
}

function handleUserstoryAjaxForm(){
	$('form.new_userstory')
	.bind("ajax:beforeSend", function(evt, xhr, settings){
		var $submitButton = $(this).find('input[name="commit"]');

		// Update the text of the submit button to let the user know stuff is happening.
		// But first, store the original text of the submit button, so it can be restored when the request is finished.
		$submitButton.data( 'origText', $(this).text() );
		$submitButton.text( "Submitting..." );

	})
	.bind("ajax:success", function(evt, data, status, xhr){
		var $form = $(this);

		// Reset fields and any validation errors, so form can be used again, but leave hidden_field values intact.
		$form.find('textarea,input[type="text"],input[type="file"]').val("");
		$form.find('div.clearfix').removeClass("error");

		// Insert response partial into page below the form.
		$form.parent().parent().find("ul").append(xhr.responseText);

	})
	.bind('ajax:complete', function(evt, xhr, status){
		var $submitButton = $(this).find('input[name="commit"]');

		// Restore the original submit button text
		$submitButton.text( $(this).data('origText') );
	})
	.bind("ajax:error", function(evt, xhr, status, error){
		var $form = $(this),
		errors,
		errorText;

		$form.find('div.clearfix').addClass("error");
		$form.find('input[name="userstory[content]"]').focus();
	});
}

function submitOnReturn(){
	$('.submit_on_return').keydown(function() {
		if (event.keyCode == 13) {
			$(this).closest('form').find('input[name="commit"]').click();
		}
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

	//hadle user story form
	handleUserstoryAjaxForm();

	//Submit on return
	submitOnReturn();
})
