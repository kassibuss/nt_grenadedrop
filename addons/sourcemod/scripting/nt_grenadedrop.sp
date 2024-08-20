#include <sourcemod>
#include <neotokyo>
#include <sdkhooks>

#define Attack_Two (1 << 11)

public Plugin myinfo =
{
    name = "NT Drop nade",
    author = "Kinoko, bauxite",
    description = "Drop a nade",
    version    = "0.1.3",
    url    = ""
};

public Action OnPlayerRunCmd(int client, int &buttons)
{
	if(!IsPlayerAlive(client))
	{
		return Plugin_Continue;
	}
    
	if(buttons & Attack_Two)
	{
		int activeweapon = GetEntPropEnt(client, Prop_Data, "m_hActiveWeapon");
            
		if(activeweapon <= 0)
		{
			return Plugin_Handled;
		}
            
		char classname[32];
            
		GetEntityClassname(activeweapon, classname, 32);
		
		if(!(StrContains(classname, "grenade", false) == -1) || !(StrContains(classname, "weapon_remotedet", false) == -1))
		{
			float ang[3], fwd[3], pos[3], aux[3];
			GetClientEyeAngles(client, ang);
			GetAngleVectors(ang, fwd, NULL_VECTOR, NULL_VECTOR);
			NormalizeVector(fwd, fwd);
			ScaleVector(fwd, 128.0);
			GetClientAbsOrigin(client, pos);
			AddVectors(pos, fwd, aux);
			
			SDKHooks_DropWeapon(client, activeweapon, aux, NULL_VECTOR, true);
			return Plugin_Handled;
		}
	}
    
	return Plugin_Continue;
}
