#include <sourcemod>
#include <neotokyo>
#include <sdkhooks>

#define Attack_Two (1 << 11) 

public Plugin myinfo =
{
    name = "NT Drop nade",
    author = "Kinoko, bauxite",
    description = "Drop a nade",
    version    = "0.1.0",
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
            return Plugin_Continue;
        }
            
        char classname[32];
            
        GetEntityClassname(activeweapon, classname, 32);
            
        if(StrContains(classname, "grenade", false) == -1)
        {
            return Plugin_Continue;
        }
        
        SDKHooks_DropWeapon(client, activeweapon, NULL_VECTOR, NULL_VECTOR, true);    
    }
    
    return Plugin_Continue;
}
