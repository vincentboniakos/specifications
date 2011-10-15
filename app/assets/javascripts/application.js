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
	$(selector).live("click",function (e){
		e.preventDefault();
		$(this).hide();
		$(this).parent().find("form.new_userstory").show();
		$(this).parent().find("form.new_userstory").find("textarea").focus();
	});
}
function hideFormNewUserStory(selector){
	$(selector).live("click",function (e){
		e.preventDefault();
		$(this).parent().hide();
		$(this).parent().parent().find("a.show_form_new_userstory").show();
	});
}

function showFormEditUserStory(selector){
	$(selector).live("click",function (e){
		e.preventDefault();
		$(this).hide();
		$li = $(this).closest("li");
		eventFormEditUserStory($li)
	});
}

function eventFormEditUserStory(object){
	object.find("div.edit_userstory").show();
	object.find("div.edit_userstory").find("textarea").focus();
	object.find("p").hide();
	object.find("a.action-link").hide();
}

function hideFormEditUserStory(selector){
	$(selector).live("click",function (e){
		e.preventDefault();
		$(this).closest("div.edit_userstory").hide();
		$(this).closest("li").find("p").show();
	});
}

function handleUserstoryAjaxForm(){
	$('form.new_userstory')
	.live("ajax:beforeSend", function (evt, xhr, settings){
		var $submitButton = $(this).find('input[name="commit"]');

		// Update the text of the submit button to let the user know stuff is happening.
		// But first, store the original text of the submit button, so it can be restored when the request is finished.
		$submitButton.data( 'origText', $(this).text() );
		$submitButton.text( "Submitting..." );
	})
	.live("ajax:success", function(evt, data, status, xhr){
		var $form = $(this);

		// Reset fields and any validation errors, so form can be used again, but leave hidden_field values intact.
		$form.find('textarea,input[type="text"],input[type="file"]').val("");
		$form.find('div.clearfix').removeClass("error");

		// Insert response partial into page below the form.
		$featuresList = $form.closest("article").find("ul");
		$featuresList.append(xhr.responseText);
		$(".action-link").hide();
	})
	.live('ajax:complete', function(evt, xhr, status){
		var $submitButton = $(this).find('input[name="commit"]');

		// Restore the original submit button text
		$submitButton.text( $(this).data('origText') );
	})
	.live("ajax:error", function(evt, xhr, status, error){
		var $form = $(this),
		errors,
		errorText;

		$form.find('div.clearfix').addClass("error");
		$form.find('input[name="userstory[content]"]').focus();
	});
}

function eventOnLi(selector) {
	$(selector).live("mouseenter",function (){		
		$(this).find('a.action-link').show();	
	}).live("mouseleave",function(){
		$(this).find('a.action-link').hide();	
	}).live("dblclick",function(){
		eventFormEditUserStory($(this))
	});
}

function handleUpdateUserstoryAjaxForm(){
	$('form.edit_userstory')
	.live("ajax:beforeSend", function (evt, xhr, settings){
		var $submitButton = $(this).find('input[name="commit"]');

		// Update the text of the submit button to let the user know stuff is happening.
		// But first, store the original text of the submit button, so it can be restored when the request is finished.
		$submitButton.data( 'origText', $(this).text() );
		$submitButton.text( "Submitting..." );
	})
	.live("ajax:success", function(evt, data, status, xhr){
		var $form = $(this);

		// Reset fields and any validation errors, so form can be used again, but leave hidden_field values intact.
		$form.find('textarea,input[type="text"],input[type="file"]').val("");
		$form.find('div.clearfix').removeClass("error");
		// Insert response partial into page below the form.
		$li = $form.closest("li");
		$li.closest("li").after(xhr.responseText);
		$li.remove();
		$(".action-link").hide();
	})
	.live('ajax:complete', function(evt, xhr, status){
		var $submitButton = $(this).find('input[name="commit"]');

		// Restore the original submit button text
		$submitButton.text( $(this).data('origText') );
	})
	.live("ajax:error", function(evt, xhr, status, error){
		var $form = $(this),
		errors,
		errorText;
		$form.find('div.clearfix').addClass("error");
		$form.find('input[name="userstory[content]"]').focus();
	});
}

function handleDeleteUserstoryAjaxLink(){
	$('.delete.action-link')
	.live("ajax:beforeSend", function (evt, xhr, settings){
		$(this).closest("li").find("p").addClass("load");
	})
	.live("ajax:success", function(evt, data, status, xhr){
		$(this).closest("li").remove();
	})
	.live('ajax:complete', function(evt, xhr, status){
		
	})
	.live("ajax:error", function(evt, xhr, status, error){
		
	});
}

function submitOnReturn(){
	$('.submit_on_return').live("keydown",function() {
		if (event.keyCode == 13) {
			event.preventDefault();
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
	
	showFormEditUserStory("a.show_form_edit_userstory");
	hideFormEditUserStory("a.hide_form_edit_userstory");
	
	//handle user story form
	handleUserstoryAjaxForm();
	
	//handle update user story form
	handleUpdateUserstoryAjaxForm();

	//Submit on return
	submitOnReturn();
	
	//Attach handler on ajax delete link
	handleDeleteUserstoryAjaxLink();
	
	//Hide delete link
	$(".action-link").hide();
	eventOnLi("article li");
	

	
	

})
