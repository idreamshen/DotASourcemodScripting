#include <sourcemod>
#include <sdktools>
 
#define PLUGIN_VERSION "1.0"
 
public Plugin:myinfo = {
	name = "Dota 2 - Auto Quit",
	author = "Matheus28",
	description = "",
	version = PLUGIN_VERSION,
	url = ""
}


static String:server_ip[255];

public OnPluginStart(){

}

public OnGameFrame() {
	GetConVarName(FindConVar("dota_gamestate"),   server_ip,   sizeof(server_ip));
	
}