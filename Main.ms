bind(player_join, null, null, @event) {
	@name = _get_name(@event["player"]);
	if(length(@name) > 16) {
		@name = substr(@name, 0, 16);
	}
	set_list_name(@event["player"], @name);
}

bind(player_chat, null, null, @event) {
	modify_event("format", colorize(_get_name(@event["player"]) . "&r: %2$s"));
	modify_event("message", colorize(@event["message"]));
}

bind(sign_changed, null, null, @event) {
	@sign = @event["text"];
	foreach(@line: @text in @sign) {
		@sign[@line] = colorize(@text);
	}
	modify_event("text", @sign);
}

export("bed.sleepyheads", associative_array());

bind(player_enter_bed, null, null, @event) {
	@beds = import("bed.sleepyheads");
	@world = @event["location"]["world"];
	@player = @event["player"];

	if(!array_index_exists(@beds, @world)) {
		@beds[@world] = 1;
	} else {
		++@beds[@world];
	}
	@percentage = @beds[@world] / array_size(all_players(@world));
	broadcast(colorize(_get_name(@player) . "&a is now sleeping (&e" . @beds[@world]
			. "/" . array_size(all_players(@world)) . "&a)."));
	if(@percentage >= 0.2) {
		set_timeout(1000, closure() {
			set_world_time(@world, 0);
			broadcast(colorize("&aThe power of beds has made it day."));
		});
	}
}

bind(player_leave_bed, null, null, @event) {
	@beds = import("bed.sleepyheads");
	@world = @event["location"]["world"];
	@player = @event["player"];

	if(array_index_exists(@beds, @world)) {
		--@beds[@world];
	}
	_set_home(@player, ploc(@player));
	tmsg(@player, colorize("&aYour &e/home&a has been set."));
}

register_command("home", associative_array(
	description: colorize("&aA basic &e/home&a command."),
	usage: "/home",
	tabcompleter: closure(@alias, @sender, @args) {
		return(array());
	},
	executor: closure(@alias, @sender, @args) {
		@home = _get_home(@sender);
		if(@home == null) {
			die(colorize("&cNo home was found."));
		}
		_teleport(@sender, @home);
	}
));

register_command("setnick", associative_array(
	description: colorize("&aA name command."),
	usage: "/setnick <nick>",
	tabcompleter: closure(@alias, @sender, @args) {
		return(array());
	},
	executor: closure(@alias, @sender, @args) {
		@args = array_implode(@args, " ");
		if(strip_colors(colorize(@args)) == "") {
			_set_name(@sender, @sender);
			die(colorize("&aReset name to &r" . @sender . "&a."));
		}
		_set_name(@sender, _last_color(@args));
		msg(colorize("&aDisplaying name as &r" . _get_name(@sender)  . "&a."));
	}
));

register_command("colorcodes", associative_array(
	description: colorize("&aShows colors and stuff."),
	usage: "/colorcodes",
	tabcompleter: closure(@alias, @sender, @args) {
		return(array());
	},
	aliases: array("colourcodes"),
	executor: closure(@alias, @sender, @args) {
		msg(colorize('&00&11&22&33&44&55&66&77&88&99&aa&bb&cc&dd&ee&ff &kk&r&ll&r&mm&r&nn&r&oo &rr'));
	}
));
