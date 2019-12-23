///////////	thederelict items

/obj/item/paper/fluff/ruins/thederelict/equipment
	info = "If the equipment breaks there should be enough spare parts in our engineering storage near the north east solar array."
	name = "Equipment Inventory"

/obj/item/paper/fluff/ruins/thederelict/syndie_mission
	name = "Mission Objectives"
	info = "The Syndicate have cunningly disguised a Syndicate Uplink as your PDA. Simply enter the code \"678 Bravo\" into the ringtone select to unlock its hidden features. <br><br><b>Objective #1</b>. Kill the God damn AI in a fire blast that it rocks the station. <b>Success!</b>  <br><b>Objective #2</b>. Escape alive. <b>Failed.</b>"

/obj/item/paper/fluff/ruins/thederelict/nukie_objectives
	name = "Objectives of a Nuclear Operative"
	info = "<b>Objective #1</b>: Destroy the station with a nuclear device."

/obj/item/paper/crumpled/bloody/ruins/thederelict/unfinished
	name = "unfinished paper scrap"
	desc = "Looks like someone started shakily writing a will in space common, but were interrupted by something bloody..."
	info = "I, Victor Belyakov, do hereby leave my _- "

// So drones can teach borgs and AI dronespeak. For best effect, combine with mother drone lawset.
/obj/item/dronespeak_manual
	name = "dronespeak manual"
	desc = "The book's cover reads: \"Understanding Dronespeak - An exercise in futility.\""
	icon = 'icons/obj/library.dmi'
	icon_state = "book2"

/obj/item/dronespeak_manual/attack_self(mob/living/user)
	..()
	if(isdrone(user) || issilicon(user))
		if(user.has_language(/datum/language/drone))
			to_chat(user, "<span class='boldannounce'>You start skimming through [src], but you already know dronespeak.</span>")
		else
			to_chat(user, "<span class='boldannounce'>You start skimming through [src], and suddenly the drone chittering makes sense.</span>")
			user.grant_language(/datum/language/drone)
		return

	if(user.has_language(/datum/language/drone))
		to_chat(user, "<span class='boldannounce'>You start skimming through [src], but you already know dronespeak.</span>")
	else
		to_chat(user, "<span class='boldannounce'>You start skimming through [src], but you can't make any sense of the contents.</span>")

/obj/item/dronespeak_manual/attack(mob/living/M, mob/living/user)
	if(!istype(M) || !istype(user))
		return
	if(M == user)
		attack_self(user)
		return

	playsound(loc, "punch", 25, TRUE, -1)
	if(isdrone(M) || issilicon(M))
		if(M.has_language(/datum/language/drone))
			M.visible_message("<span class='danger'>[user] beats [M] over the head with [src]!</span>", "<span class='userdanger'>[user] beats you over the head with [src]!</span>", "<span class='hear'>You hear smacking.</span>")
		else
			M.visible_message("<span class='notice'>[user] teaches [M] by beating [M.p_them()] over the head with [src]!</span>", "<span class='boldnotice'>As [user] hits you with [src], chitters resonate in your mind.</span>", "<span class='hear'>You hear smacking.</span>")
			M.grant_language(/datum/language/drone)
		return