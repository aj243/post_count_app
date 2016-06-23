count = 0
source = new EventSource("users/events");
source.addEventListener("message", function(response) {
	count = response.data;
	$('#post_field').val(count);
});