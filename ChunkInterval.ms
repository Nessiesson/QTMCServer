set_interval(5000, closure() {
	foreach(@player in all_players()) {
		@loc = ploc(@player);
		for(@i = -32, @i <= 32, @i += 16) {
			for(@j = -32, @j <= 32, @j += 16) {
				refresh_chunk(associative_array(world: @loc["world"], x: @loc["x"] + @i, z: @loc["z"] + @j));
			}
		}
	}
});
