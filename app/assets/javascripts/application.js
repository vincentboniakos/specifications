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
			//console.log($value_str);
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

function showHideDeleteComment(selector){
	$(selector).mouseenter(function (){		
		$(this).find('a.delete').attr("style","");	
	}).mouseleave(function(){
		$(this).find('a.delete').attr("style","display:none;");	
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

function handleDeleteCommentAjaxLink(){
	$('article.comment a.delete')
	.live("ajax:beforeSend", function (evt, xhr, settings){
		//
	})
	.live("ajax:success", function(evt, data, status, xhr){
		$(this).closest("article").fadeOut();
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

function toggleFeatureSize(e)
{
	var projectId = $('#project').attr('data-project-id');

	if (e) {
		var featureId = $(e.target).attr("feature_id");
		var $targetArticle = $("#a_feature_"+featureId);
		//hack pour connaitre l'état du toggle
		var currentState = ($("article#a_feature_"+featureId+" .feature-content").slideToggle().css("height").replace(/(px)/, "")*1 > 20);

		//si compatible local storage
		if(localStorage){
			//on récupere la variable si elle existe sinon on en créé une nouvelle
			if(localStorage.getItem("5gSpecifications-minimize")){
				storableObject = JSON.parse( localStorage.getItem("5gSpecifications-minimize") );
			} else {
				storableObject = {};
			}

			//le projet existe déja en local storage ?
			if (!storableObject[projectId])
				storableObject[projectId] = {};

			//créé une entrée pour la feature concerné ou supprime l'entré selon le toggle
			if (currentState) {
				storableObject[projectId][featureId] = currentState;
			} else {
				delete storableObject[projectId][featureId]; 
			}

			//save
			localStorage.setItem("5gSpecifications-minimize", JSON.stringify(storableObject));
		}
	} else {
		if(localStorage){
			if(!localStorage.getItem("5gSpecifications-minimize"))
				return;

			storableObject = JSON.parse( localStorage.getItem("5gSpecifications-minimize") );

			if(storableObject[projectId]){
				//console.log(storableObject);
				for(var featureId in storableObject[projectId]){
					if ($("article#a_feature_"+featureId).length) {
						$("article#a_feature_"+featureId+" .feature-content").hide();
					} else {
						delete storableObject[projectId][featureId];
					}
				}
			}
			//save
			localStorage.setItem("5gSpecifications-minimize", JSON.stringify(storableObject));
		}
	};
}

function sortableFeatures(selector){
	$(selector).sortable({
		axis: 'y',
		items: "article",
		handle: '.article-handle',
		tolerance: "pointer",
		opacity: 0.4,
		start: function(event, ui) {

			// $(".feature-content").hide();
            var start_pos = ui.item.index();
            var last_pos = start_pos;
            ui.item.data('start_pos', start_pos);
            ui.item.data('last_pos', last_pos);
        },
        change: function(event, ui) {
            var start_pos = ui.item.data('start_pos');
            var last_pos = ui.item.data('last_pos');
            var index = ui.placeholder.index();

            if (index > start_pos) --index;
            var $obj = $($("nav.features li")[last_pos]);
            $obj.detach();
            if (last_pos < index) {
				$obj.insertAfter($($("nav.features li")[last_pos]));
            } else {
				$obj.insertBefore($($("nav.features li")[index]));
            }
            
            ui.item.data('last_pos', index);
        },
        update: function(event, ui) {
			var serial = "";
			var artTab = $("section.features article");
			for (var i = 0; i < artTab.length; i++) {
				artTab[i] = $(artTab[i]).attr("id").replace(/(a_feature_)/, "");
				serial += ""+artTab[i]+"="+i;
				if(i!=artTab.length - 1) serial+= "&";
			};
			//console.log(serial);
			$.ajax({
				type: 'post',
				data: serial,
				url: '/projects/'+$('#project').attr('data-project-id')+'/feature/sort'
			})
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
        //console.log(array.join('&'));
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
        $(event.target.hash).addClass("highlight-feature");
    });
    $("a.anchor[href^='#']").mouseleave(function(event){
		$(event.target.hash).removeClass("highlight-feature");
	});
}

function updateActivity(){
	$.get('/projects/'+$('#project').attr('data-project-id')+'/activity', function(data) {
  		$('#activity .empty').remove();
  		$('#activity table tbody').html(data);
	});
}

function handleCommentAjaxForm(){
	$('form.new_comment')
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
		$('#comments').append(xhr.responseText);
		$("#comments article.comment a.delete").hide();
		showHideDeleteComment("article.comment");
		
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
		$form.find('input[name="comment[body]"]').focus();

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
	$(".size_action").click(toggleFeatureSize);
	toggleFeatureSize();


	sortableUserstories("ul.userstories");

	smoothScrolling();

	

    // Tabs
	$('.tabs').tabs();

	$('.topbar').dropdown();

	// Infinite scroll on activity
	var $loading ="<div class='load'><img src='/assets/loading.gif'/></div>"
	$footer = $('footer'),
	opts = {
		offset: '100%'
	},
	page = 1;
	$footer.waypoint(function(event, direction) {
		$footer.waypoint('remove');
		$('#activity').append($loading);
		page ++;
		$.get('/projects/'+$('#project').attr('data-project-id')+'/activity?page='+page, function(data) {
  			$('#activity table tbody').append(data);
  			$('#activity div.load').remove();
  			$footer.waypoint(opts);
		});
	},{offset:'200'});

	handleCommentAjaxForm();

	$("#comments article.comment a.delete").hide();
	showHideDeleteComment("article.comment");

	handleDeleteCommentAjaxLink();

})
