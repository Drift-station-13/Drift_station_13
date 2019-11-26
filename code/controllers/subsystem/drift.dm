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

	var/drift_x_rate = 0.9
	var/drift_y_rate = 0.1
	var/drift_x = 0.0
	var/drift_y = 0.0

/datum/controller/subsystem/drift/Initialize(timeofday)
	. = ..()

/datum/controller/subsystem/drift/fire(resumed = 0)

	if (!resumed)
		src.currentrun = GLOB.clients.Copy()
	var/list/currentrun = src.currentrun//cache for sanic speed (lists are references anyways)


	drift_x += drift_x_rate
	drift_y += drift_y_rate
	var/updated = FALSE
	if(drift_x < 1 || drift_x > -1)
		updated = TRUE
	if(drift_y < 1 || drift_y > -1)
		updated = TRUE

	if(updated == FALSE)
		return

	// run set value & update_parallax on all clients


	drift_x = 0
	drift_y = 0