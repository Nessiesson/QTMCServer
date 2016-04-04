proc _uuid(@player) {
	return(puuid(@player, true));
}

proc _teleport(@player, @location) {
	tmsg(@player, colorize("&aTeleporting in &e5&a seconds. Be prepared."));
	set_timeout(5000, closure() {
		if(!ponline(@player)) {
			return();
		}
		if(pinfo(@player, 5) == 0) {
			tmsg(@player, colorize("&cYou're dead. Cancelled teleportation."));
		}
		set_ploc(@player, @location);
	});
}

proc _get_home(@player) {
	if(pbed_location(@player) != null) {
		return(pbed_location(@player));
	} else {
		return(get_value("data." . _uuid(@player) . ".home"));
	}
}

proc _set_home(@player, @location) {
	store_value("data." . _uuid(@player) . ".home", @location);
}

proc _get_name(@player) {
	@data = get_value("data." . _uuid(@player) . ".name");
	if(@data) {
		return(@data);
	} else {
		return(colorize("&f" . player(@player)));
	}
}

proc _set_name(@player, @name) {
	@name = colorize(@name);
	store_value("data." . _uuid(@player) . ".name", @name);
	if(ponline(@player)) {
		if(length(@name) > 16) {
			@name = substr(@name, 0, 16);
		}
		set_list_name(@player, @name);
	}
}

proc _last_color(@string) {
	@string = colorize(@string);
	@color = "";
	for(@i = length(@string) - 1, @i >= 0, @i--) {
		if(@string[@i] == "\u00A7") {
			@prevchar = @string[@i + 1];
			if(reg_match("[0-9a-fklmnor]", @prevchar)) {
				@color = "&" . @prevchar . @color;

				if(reg_match("[0-9a-f]", @prevchar)) {
					break();
				}
			}
		}
	}
	return(@color);
}

proc _tps() {
	return(split(", ", split(": ", replace(strip_colors(capture_runas("~console", "/spigot:tps")), "*", ""))[1]));
}

proc _launch_firework(@location) {
	@typeArray = array(
		"BALL",
		"BALL_LARGE",
		"STAR",
		"BURST",
		"CREEPER",
	);
	@colorArray = array(
		"WHITE",
		"BLUE",
		"FUCHSIA",
		"MAROON",
		"GREEN",
		"GREY",
		"AQUA",
		"OLIVE",
		"NAVY",
		"SILVER",
		"YELLOW",
		"BLACK",
		"LIME",
		"ORANGE",
		"PURPLE",
		"RED",
		"GRAY",
		"TEAL",
	);
	@firework = associative_array();
	@firework["strength"] = rand(0, 5);
	@firework["flicker"] = rand(0, 2);
	@firework["trail"] = rand(0, 2);
	@firework["type"] = @typeArray[rand(0, array_size(@typeArray))];
	@firework["colors"] = array();
	@firework["fade"] = array();
	@colorsRandom = array_rand(@colorArray, rand(1, 19));
	foreach(@c in @colorsRandom) {
		@firework["colors"][] = @colorArray[@c];
	}
	@fadeRandom = array_rand(@colorArray, rand(1, 19));
	foreach(@f in @fadeRandom) {
		@firework["fade"][] = @colorArray[@f];
	}
	@location["y"] += 1;
	launch_firework(@location, @firework);
};
