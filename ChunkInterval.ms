set_interval(5000, closure() {
	foreach(@world in get_worlds()) {
		foreach(@chunk in get_loaded_chunks(@world)) {
			queue_push(closure() {
				refresh_chunk(@chunk);
			});
		}
	}
});
