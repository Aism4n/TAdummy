// DEBUG FILE - DELETE LATER
/obj/machinery/light/rogue/candle/off/Destroy()
	if(SSatoms.initialized == 2 || SSatoms.initialized == 0)
		var/turf/T = get_turf(src)
		if(T)
			WARNING("DEBUG: candle/off was deleted at [T.x], [T.y], [T.z] during map load!")
	return ..()