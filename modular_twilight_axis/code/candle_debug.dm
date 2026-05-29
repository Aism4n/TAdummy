// DEBUG FILE - DELETE LATER
/obj/machinery/light/rogue/candle/off/Destroy()
	if(SSatoms.initialized == 2 || SSatoms.initialized == 0)
		var/turf/T = get_turf(src)
		if(T)
			WARNING("DEBUG: candle/off was deleted at [T.x], [T.y], [T.z] during map load!")
	return ..()

/turf/PlaceOnTop(list/new_baseturfs, turf/fake_turf_type, flags)
	var/list/old_bt = baseturfs
	if(islist(old_bt) && length(old_bt) >= 10)
		var/bt_str = ""
		for(var/bt in old_bt)
			bt_str += "[bt] | "
		WARNING("DEBUG PLACEONTOP: baseturfs limit reached at [x],[y],[z]. Placing: [fake_turf_type]. Current baseturfs: [bt_str]")
	return ..()

/datum/controller/subsystem/dungeon_generator/try_grow_at_marker(obj/effect/dungeon_directional_helper/helper)
	var/turf/origin = get_turf(helper)
	if(origin)
		var/list/bt = origin.baseturfs
		if(islist(bt) && length(bt) >= 5)
			WARNING("DEBUG DUNGEON: Marker at [origin.x],[origin.y],[origin.z] is on heavily stacked turfs ([length(bt)]). Dir: [helper.dir].")
	return ..()

/datum/map_template/dungeon/load(turf/T, centered = FALSE)
	if(T)
		var/list/bt = T.baseturfs
		if(islist(bt) && length(bt) >= 5)
			WARNING("DEBUG DUNGEON TEMPLATE: [type] is loading at [T.x],[T.y],[T.z] where baseturfs length is already [length(bt)]!")
	return ..()