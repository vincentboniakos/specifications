function subscribeToPush() {
	var pusher = new Pusher($('.new_userstory').attr('data-pusher-key'));
	var channel = pusher.subscribe('userstories-channel');
	channel.bind('new_userstory', function(data) {
		//console.log($("#"+$(data.render[0]).attr('id')).length);
		if (! $("#"+$(data.render[0]).attr('id')).length) {
			$(".userstories#feature_"+data.feature).append($(data.render[0]));
			//updatePosition();
			$(".action-link").hide();
		};
	});
}