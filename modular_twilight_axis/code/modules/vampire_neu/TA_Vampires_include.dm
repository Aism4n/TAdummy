/*
	Twilight Axis vampire module include aggregator.

	Usage:
	- Include this file below upstream vampire includes.
	- Then disable raw mirror files here by hand if they conflict in late-include mode.

	Notes:
	- Order mostly follows upstream roguetown.dme.
	- living_modifications.dm is kept before bloodsuck.dm on purpose for the
	  downstream TA_* policy hooks.
	- THRALLS_* are loaded from vampires_defines.dm and cleared at the bottom
	  via TA_Vampires_uniclude.dm.
*/

// Early define slot and shared cross-module vampire hooks.
#include "./vampires_defines.dm"

//#include "./overrides/living_modifications.dm"
#include "./overrides/bloodsuck.dm"
#include "./overrides/pallid_addiction.dm"
#include "./overrides/pallid_spells.dm"
#include "./overrides/quicksilver.dm"
#include "./overrides/transfix.dm"
#include "./overrides/vampire.dm"
#include "./overrides/vampire_hud.dm"
// Main vampire_neu block.
/*  // HOT FIX
#include "./overrides/helpers.dm"
#include "./overrides/_base_clan.dm"
#include "./overrides/_base_power.dm"
#include "./overrides/_actions.dm"

// MISC
#include "./other_files/TA_vampire_disguise.dm"
#include "./other_files/TA_sun_hater.dm"


*/ // HOT FIX
// Local defines
#include "./TA_Vampires_uniclude.dm"
