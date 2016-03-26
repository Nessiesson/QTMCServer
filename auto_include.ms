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
		return(colorize(@data . player(@player)));
	} else {
		return(player(@player));
	}
}

proc _set_name(@player, @name) {
	@name = colorize(@name);
	store_value("data." . _uuid(@player) . ".name", @name);
	if(ponline(@player)) {
		if(length(@name) > 16) {
			@name = substr(@name . player(@player), 0, 16);
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
