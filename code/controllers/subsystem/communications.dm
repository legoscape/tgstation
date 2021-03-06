#define COMMUNICATION_COOLDOWN 600
#define COMMUNICATION_COOLDOWN_AI 600

var/datum/controller/subsystem/communications/SScommunications

/datum/controller/subsystem/communications
	name = "Communications"
	flags = SS_NO_INIT | SS_NO_FIRE

	var/silicon_message_cooldown
	var/nonsilicon_message_cooldown

/datum/controller/subsystem/communications/New()
	NEW_SS_GLOBAL(SScommunications)

/datum/controller/subsystem/communications/proc/can_announce(mob/living/user, is_silicon)
	if(is_silicon && silicon_message_cooldown > world.time)
		. = FALSE
	else if(!is_silicon && nonsilicon_message_cooldown > world.time)
		. = FALSE
	else
		. = TRUE

/datum/controller/subsystem/communications/proc/make_announcement(mob/living/user, is_silicon, input)
	if(!can_announce(user, is_silicon))
		return FALSE
	if(is_silicon)
		minor_announce(html_decode(input),"[user.name] Announces:")
		silicon_message_cooldown = world.time + COMMUNICATION_COOLDOWN_AI
	else
		priority_announce(html_decode(input), null, 'sound/misc/announce.ogg', "Captain")
		nonsilicon_message_cooldown = world.time + COMMUNICATION_COOLDOWN
	log_say("[key_name(user)] has made a priority announcement: [input]")
	message_admins("[key_name_admin(user)] has made a priority announcement.")

#undef COMMUNICATION_COOLDOWN
#undef COMMUNICATION_COOLDOWN_AI
