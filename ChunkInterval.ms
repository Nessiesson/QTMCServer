set_interval(5000, closure() {
	foreach(@player in all_players()) {
		@loc = ploc(@player);
		for(@i = -16, @i <= 16, @i += 16) {
			for(@j = -16, @j <= 16, @j += 16) {
				refresh_chunk(associative_array(world: @loc["world"], x: @loc["x"] + @i, z: @loc["z"] + @j));
			}
		}
	}
});
