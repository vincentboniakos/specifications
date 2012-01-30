// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .


///// PLUGIN 

function Utils(){


this.debug = function($value_str){
if (window.console) {
console.log($value_str);
}else {
alert($value_str);
}
}
}
var _utils5g =  new Utils();


////////////


function showHideEditLink(selector){
	$(selector).mouseenter(function (){		
	    $(this).find('small').show();
	    $(this).find('.action-link').show();	
	}).mouseleave(function(){
		$(this).find('small').hide();       	
		$(this).find('.action-link').hide();	
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
	object.find(".action-link").hide();
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
		$submitButton.attr('disabled','disabled');
	})
	.live("ajax:success", function(evt, data, status, xhr){
		var $form = $(this);

		// Reset fields and any validation errors, so form can be used again, but leave hidden_field values intact.
		$form.find('textarea,input[type="text"],input[type="file"]').val("");
		$form.find('div.clearfix').removeClass("error");

		// Insert response partial into page below the form.
		$featuresList = $form.closest("article").find("ul");
		$featuresList.append(xhr.responseText);
		$featuresList.find("li").last().find("p").addClass("flash").delay(200).queue(function(next){
		   $(this).removeClass("flash");

		});
		//updatePosition();
		$(".action-link").hide();
		updateActivity();
	})
	.live('ajax:complete', function(evt, xhr, status){
		var $submitButton = $(this).find('input[name="commit"]');

		// Restore the original submit button state
		$submitButton.removeAttr('disabled');
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
		$(this).find('.action-link').show();	
	}).live("mouseleave",function(){
		$(this).find('.action-link').hide();	
	}).live("dblclick",function(){
		eventFormEditUserStory($(this))
	});
}

function handleUpdateUserstoryAjaxForm(){
	$('form.edit_userstory')
	.live("ajax:beforeSend", function (evt, xhr, settings){
		var $submitButton = $(this).find('input[name="commit"]');

		$submitButton.attr('disabled','disabled');
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
		updateActivity();
	})
	.live('ajax:complete', function(evt, xhr, status){
		var $submitButton = $(this).find('input[name="commit"]');

		$submitButton.removeAttr('disabled');
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
		updateActivity();
	})
	.live('ajax:complete', function(evt, xhr, status){
		
	})
	.live("ajax:error", function(evt, xhr, status, error){
		
	});
}

function submitOnReturn(){
	$('.submit_on_return').live("keydown",function(event) {
		if (event.keyCode == 13) {
			event.preventDefault();
			$(this).closest('form').find('input[name="commit"]').click();
			return false;
		}
	});
}

function sortableFeatures(selector){
	$(selector).sortable({
		axis: 'y',
		items: "article",
		handle: '.article-handle',
		tolerance: "pointer",
		opacity: 0.4,
		start: function(){

		}
	});
}

function sortableUserstories(selector){
	$(selector).sortable({
		axis: 'y',
		dropOnEmpty: false,
		handle: '.handle',
		cursor: 'move',
		items: "li",
		connectWith: '.userstories',
		opacity: 0.4,
		scroll: true,
		update: function (){
			updatePosition ();
		}
	});
}

function updatePosition (){
	$.ajax({
		type: 'post',
		data: $(".userstories").serial(),
		dataType: 'script',
		url: '/projects/'+$('#project').attr('data-project-id')+'/userstories/sort'
	})
}


(function($) {
    $.fn.serial = function() {
        var array = [];
        var $elem = $(this);
        $elem.each(function(i) {
            var feature = this.id.split('_')[1];
            $('li', this).each(function(e) {
                array.push(feature + '[' + e + ']=' + this.id.split('_')[1]);
            });
        });
        return array.join('&');
    }
})(jQuery);

function smoothScrolling(){
	var scrollElement = 'html, body';
    $('html, body').each(function () {
        var initScrollTop = $(this).attr('scrollTop');
        $(this).attr('scrollTop', initScrollTop + 1);
        if ($(this).attr('scrollTop') == initScrollTop + 1) {
            scrollElement = this.nodeName.toLowerCase();
            $(this).attr('scrollTop', initScrollTop);
            return false;
        }    
    });

    // Smooth scrolling for internal links
    $("a.anchor[href^='#']").click(function(event){
		event.preventDefault();
        
        $(scrollElement).stop().animate({
            'scrollTop': $(event.target.hash).offset().top - 100
        }, 500, 'swing', function() {
        });
    });

    //highlight match article
    $(".features>article").mouseenter(function(event){
		var $featureLink = $(".anchor[feature-id = "+$(this).attr('id')+"]");
		$featureLink.addClass("anchorHover");
        //$(this).addClass("highlight-feature");
    });
    $(".features>article").mouseleave(function(event){
		var $featureLink = $(".anchor[feature-id = "+$(this).attr('id')+"]");
		$featureLink.removeClass("anchorHover");
        //$(this).removeClass("highlight-feature");
    });

    //highlight matching article
    $("a.anchor[href^='#']").mouseenter(function(event) {
		console.info(event.target.hash);
        $(event.target.hash).addClass("highlight-feature");
    });
    $("a.anchor[href^='#']").mouseleave(function(e){
		$(event.target.hash).removeClass("highlight-feature");
	});
}

function updateActivity(){
	$.get('/projects/'+$('#project').attr('data-project-id')+'/activity', function(data) {
		$('#activity').html(data);
	});
}

$(document).ready(function () {
	// Alert
	$(".alert-message").alert();
	$(".alert-message").delay(12000).fadeOut('slow');

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


	sortableFeatures(".features");
	sortableUserstories("ul.userstories");

	smoothScrolling();

	$.waypoints.settings.scrollThrottle = 50;
    $('nav.breadcrumb').waypoint(function(event, direction) {
			$(this).toggleClass('sticky', direction === "down");
	        event.stopPropagation();
	    },{
	        offset: 47
	    });

    $('nav.features').waypoint(function(event, direction) {
			$(this).toggleClass('sticky', direction === "down");
			event.stopPropagation();
		},{
			offset: 90
		});

	$('.tabs').tabs();

})
