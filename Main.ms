bind(player_join, null, null, @event) {
	@player = @event["player"];
	@name = _get_name(@player);

	if(length(@name) > 16) {
		@name = substr(@name, 0, 16);
	}
	set_list_name(@player, @name);
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
	broadcast(colorize(_get_name(@player) . "&a is now sleeping (&e"
			. @beds[@world]	. "&a/&e" . array_size(all_players(@world))
			. "&a)."));
	if(@percentage >= 0.2) {
		set_timeout(1000, closure() {
			set_world_time(@world, 0);
			storm(false, @world);
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

bind(player_interact, null, associative_array(item: data_values("clock")), @event) {
	if(@event["action"] == "left_click_block" || @event["action"] == "left_click_air") {
		die();
	}
	@player = @event["player"];
	if((time() - import("fireworks.@player.cooldown")) >= 250) {
		_launch_firework(ploc(@player));
		export("fireworks.@player.cooldown", time());
	}
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

register_command("setname", associative_array(
	description: colorize("&aA name command."),
	usage: "/setname <nick>",
	tabcompleter: closure(@alias, @sender, @args) {
		if(array_size(@args) == 1) {
			return(array("clear"));
		} else {
			return(array());
		}
	},
	aliases: array("setcolor", "setcolour"),
	executor: closure(@alias, @sender, @args) {
		@args = array_implode(@args, " ");
		if(@args == "") {
			die(colorize("&aUsage: &e" . reflect_pull("command") . " <nick|clear>\n"));
		}
		if(to_lower(@args) == "clear") {
			_set_name(@sender, "&f" . @sender);
			die(colorize("&aName cleared."));
		}
		_set_name(@sender, _last_color(@args) . @sender);
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

register_command("lag", associative_array(
	description: colorize("&aShows various information that may be useful."),
	usage: "/lag",
	tabcompleter: closure(@alias, @sender, @args) {
		return(array());
	},
	executor: closure(@alias, @sender, @args) {
		@chunks = 0;
		foreach(@world in get_worlds()) {
			@chunks += array_size(get_loaded_chunks(@world));
		}
		msg(colorize("&aThere are currently &e" . array_size(all_entities()) . " &aentities and &e@chunks &aloaded chunks.\n"
				. "&aThere are &e" . array_size(all_players()) . " &aplayer(s) online with a TPS of &e"
				. array_implode(_tps(), "&a, &e")));
		
		if(array_index_exists(@args, 0) && to_lower(@args[0]) == "all") {
			foreach(@player in all_players()) {
				msg(colorize(_get_name(@player) . "&a: &e" . array_size(entities_in_radius(ploc(@player), 16 * 10))
						." &aentities in area."));
			}
		}
	}
));
