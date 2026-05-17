/*
	Twilight Axis vampire module include aggregator.

	Usage:
	- Include this file below upstream vampire includes.

	Notes:
	- Order mostly follows upstream roguetown.dme.
	- THRALLS_* are loaded from vampires_defines.dm and cleared at the bottom
	  via TA_Vampires_uniclude.dm.
*/

// Early define slot and shared cross-module vampire hooks.
#include "./vampires_defines.dm"

#include "./overrides/bloodsuck.dm"
#include "./overrides/portal.dm"
#include "./ascended_covens.dm"
#include "./coven_level_purchases.dm"
#include "./crimson_crucible_ru_i18n.dm"
#include "./overrides/pallid_addiction.dm"
#include "./overrides/pallid_spells.dm"
#include "./overrides/quicksilver.dm"
#include "./overrides/transfix.dm"
#include "./i18n/russian_language.dm"
#include "./overrides/vampire.dm"

// Local defines
#include "./TA_Vampires_uniclude.dm"
