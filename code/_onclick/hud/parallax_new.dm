/client
	var/list/parallax_layers
	var/turf/previous_turf

	var/atom/movable/movingmob

	var/parallax_last_x = 0
	var/parallax_last_y = 0

/datum/hud/proc/create_parallax(mob/viewmob)
	var/mob/screenmob = viewmob || mymob
	var/client/C = screenmob.client

	var/turf/posobj = get_turf(C.eye)
	C.parallax_last_x = posobj.x
	C.parallax_last_y = posobj.y

	if(C.prefs.parallax == PARALLAX_DISABLE)
		return

	C.parallax_layers = list()
	var/obj/B = new /obj/ys_screen/parallax_layer/layer_1(null, C.view)
	B.transform *= 1
	C.parallax_layers += B
	C.screen |= (C.parallax_layers) // adds any parallax_layers to screen that are not already in screen

	var/obj/screen/plane_master/PM = screenmob.hud_used.plane_masters["[PLANE_SPACE]"]
	if(screenmob != mymob)
		C.screen -= locate(/obj/screen/plane_master/parallax_white) in C.screen
		C.screen += PM
	PM.color = list(
		0, 0, 0, 0,
		0, 0, 0, 0,
		0, 0, 0, 0,
		1, 1, 1, 1,
		0, 0, 0, 0
		)

/datum/hud/proc/remove_parallax(mob/viewmob)
	var/mob/screenmob = viewmob || mymob
	var/client/C = screenmob.client

	C.screen -= (C.parallax_layers)
	C.parallax_layers = null

	var/obj/screen/plane_master/PM = screenmob.hud_used.plane_masters["[PLANE_SPACE]"]
	if(screenmob != mymob)
		C.screen -= locate(/obj/screen/plane_master/parallax_white) in C.screen
		C.screen += PM
	PM.color = initial(PM.color)


/datum/hud/proc/update_parallax()
	var/client/C = mymob.client
	var/turf/posobj = get_turf(C.eye)
	if(!posobj)
		return

	warning("update_parallax was called!")
	TODO MOVE THIS LOGIC, this only gets called a few times.
	that or figure out how to do this on a movment event

	var/diff_x = C.parallax_last_x - posobj.x
	var/diff_y = C.parallax_last_y - posobj.y

	for(var/obj/ys_screen/parallax_layer/L in C.parallax_layers)
		/*
		L.offset_x += diff_x
		var/pos_rend_x = L.offset_x
		L.offset_y += diff_y
		var/pos_rend_y = L.offset_y
		*/
		L.offset_x += 1
		L.offset_y += 1
		if(L.offset_x > 500)
			L.offset_x = 0
			L.offset_y = 0
		L.screen_loc = "CENTER-10:[L.offset_x],CENTER-7:[L.offset_y]"

	C.parallax_last_x = posobj.x
	C.parallax_last_y = posobj.y

/atom/movable/proc/update_parallax_contents()
	return

/atom/movable/proc/update_parallax_teleport()
	return

/datum/hud/proc/update_parallax_pref(mob/viewmob)
	remove_parallax(viewmob)
	create_parallax(viewmob)
	update_parallax()


/obj/ys_screen/parallax_layer
	icon = 'icons/effects/parallax.dmi'
	blend_mode = BLEND_OVERLAY//BLEND_ADD
	plane = PLANE_SPACE_PARALLAX
	screen_loc = "CENTER-10,CENTER-7"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 255

	var/offset_x = 0
	var/offset_y = 0

/obj/ys_screen/parallax_layer/layer_1
	//icon_state = "debug"
	icon = 'icons/Testing/background.png'