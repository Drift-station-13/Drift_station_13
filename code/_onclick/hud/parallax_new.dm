/client
	var/list/parallax_layers
	var/turf/previous_turf

	var/atom/movable/movingmob

/datum/hud/proc/create_parallax(mob/viewmob)
	var/mob/screenmob = viewmob || mymob
	var/client/C = screenmob.client

	if(C.prefs.parallax == PARALLAX_DISABLE)
		return

	C.parallax_layers = list()
	var/obj/B = new /obj/screen/parallax_layer/layer_1(null, C.view)
	B.transform *= 1
	C.parallax_layers += B
	C.screen |= (C.parallax_layers) // adds any parallax_layers to screen that are not already in screen

	// ??!?!?!??
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


/datum/hud/proc/update_parallax()
	return

/atom/movable/proc/update_parallax_contents()
	return

/atom/movable/proc/update_parallax_teleport()
	return

/datum/hud/proc/update_parallax_pref(mob/viewmob)
	remove_parallax(viewmob)
	create_parallax(viewmob)
	update_parallax()


/obj/screen/parallax_layer
	icon = 'icons/effects/parallax.dmi'
	blend_mode = BLEND_ADD
	plane = PLANE_SPACE_PARALLAX
	screen_loc = "CENTER-7,CENTER-7"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/screen/parallax_layer/layer_1
	icon_state = "layer1"