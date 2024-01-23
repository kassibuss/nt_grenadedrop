#include <sourcemod>
#include <sdktools>
#include <dhooks>

#include <neotokyo>

#pragma semicolon 1
#pragma newdecls required

#define AMMO_GRENADE	1 // Not sure if defining is needed, remove unless necessary?
#define AMMO_SMOKE		2

public Plugin myinfo =
{
    name = "Neotokyo Grenade Drop",
    author = "kinoko",
    description = "Enables dropping grenades during the freeze time of the round",
    version = PLUGIN_VERSION,
    url = ""
};  

public void OnPluginStart()
{
    hEnabled = CreateConvar("sm_grenadedrop", "0", ADMFLAG_GENERIC, "Enables dropping grenades.");
    HookConVarChange(hEnabled, toggle_plugin)
    HookEvent("game_round_start", event_RoundStart);
}

public void Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
    if SetConVarInt(hEnabled, 1);
        return Plugin_Continue;
}

public void OnClientPutInServer(int client)
{
	SDKHook(client, SDKHook_DropWeapon, OnWeaponDrop);
}

public void OnWeaponDrop(int client, int weapon)
{
    if(!GameRules_GetProp("m_bFreezePeriod"))
	return Plugin_Continue;
            
    if(!IsValidEdict(weapon))
		return;

	char classname[32];
	if(!GetEntityClassname(weapon, classname, sizeof(classname)))
		return; 

	if(!StrEqual(classname, "weapon_grenade"))
		return;
    
    else if(!StrEqual(classname, "weapon_smokegrenade"))
		return;
        
	g_fLastWeaponDroppedTime[client] = GetGameTime();
}
