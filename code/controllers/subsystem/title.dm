SUBSYSTEM_DEF(title)
	name = "Title Screen"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_TITLE

	var/file_path
	var/icon/icon
	var/icon/previous_icon
	var/turf/closed/indestructible/splashscreen/splash_turf

/datum/controller/subsystem/title/Initialize()
	if(file_path && icon)
		return

	SSmapping.HACK_LoadMapConfig()

	var/list/start_screen_file_list = flist("icons/title_screen/images/")
	var/start_screen_pick = rand(1, start_screen_file_list.len)
	file_path = "icons/title_screen/images/" + start_screen_file_list[start_screen_pick]

	ASSERT(fexists(file_path))

	icon = new(fcopy_rsc(file_path))

	if(splash_turf)
		splash_turf.icon = icon

	return ..()

/datum/controller/subsystem/title/vv_edit_var(var_name, var_value)
	. = ..()
	if(.)
		switch(var_name)
			if("icon")
				if(splash_turf)
					splash_turf.icon = icon

/datum/controller/subsystem/title/Shutdown()
	for(var/thing in GLOB.clients)
		if(!thing)
			continue
		var/obj/screen/splash/S = new(thing, FALSE)
		S.Fade(FALSE,FALSE)

/datum/controller/subsystem/title/Recover()
	icon = SStitle.icon
	splash_turf = SStitle.splash_turf
	file_path = SStitle.file_path
	previous_icon = SStitle.previous_icon