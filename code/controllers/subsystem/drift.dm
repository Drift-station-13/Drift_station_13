/*
	Note that Drifting takes over the functionality of parallax
	including its subsystem.
*/

SUBSYSTEM_DEF(drift)
	name = "Drift"
	wait = 1 SECONDS
	flags = SS_POST_FIRE_TIMING | SS_BACKGROUND
	priority = FIRE_PRIORITY_PARALLAX
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	var/list/currentrun

	var/drift_x_rate = 0.5
	var/drift_y_rate = -1
	var/drift_x = 0.0
	var/drift_y = 0.0

/datum/controller/subsystem/drift/Initialize(timeofday)
	. = ..()

/datum/controller/subsystem/drift/proc/parallax()
	if(!currentrun)
		return
	for(var/client/C in currentrun)
		if (!C || !C.eye)
			continue
		if(!C.mob.hud_used)
			continue
		C.mob.hud_used.update_parallax()

/datum/controller/subsystem/drift/fire(resumed = 0)

	if (!resumed)
		src.currentrun = GLOB.clients.Copy()
	currentrun = src.currentrun//cache for sanic speed (lists are references anyways)

	drift_x += drift_x_rate
	drift_y += drift_y_rate
	parallax()