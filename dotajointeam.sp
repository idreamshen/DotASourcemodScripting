#include <sourcemod>
#include <sdktools>
 
#define PLUGIN_VERSION "1.1"
//new PlayerCount = 0;
new GameEnded = 0;
new LastMap = 0;
 
public Plugin:myinfo = {
        name = "Dota 2 - AutoJoinTeam",
        author = "M72TheLaw",
        description = "",
        version = PLUGIN_VERSION,
        url = ""
}

static Handle:game_mode;
 
public OnPluginStart(){
 
        CreateTimer(1.0,Timer_GameState, _, TIMER_REPEAT);
		game_mode   = CreateConVar("game_mode",   "0", "test.");
}
 
public Action:Timer_GameState(Handle:timer)
{
        if (GameEnded == 0 && GameRules_GetProp("m_nGameState") == 6)
        {
                GameEnded = 1;
                //PrintToChatAll("Game ended, server will reload in 10 seconds")
				PrintToChatAll("比赛结束,地图将在60秒后重建");
                CreateTimer(60.0,Timer_ReloadMap);
        }
}
public Action:Timer_ReloadMap(Handle:timer)
{
        GameEnded = 0;
        //PrintToChatAll("You were kicked so that the server could reset,you can reconnect at any time.");
        Load_New_Map();
 
}
 
public Load_New_Map()
{
	/*
        if( LastMap == 0 )
        {
                ServerCommand("map dota");
        }
        else if( LastMap == 1 )
        {
                ServerCommand("map dota_winter");      
        }
        else if( LastMap == 2 )
        {
                ServerCommand("map dota_autumn");      
        }
       
        if( LastMap >= 2 )
        {
                LastMap = 0;   
        }
        else
        {
                LastMap++;
        }
	*/
	ServerCommand("quit");
}

public OnClientDisconnect_Post(client)
{      
        if((GetTeamClientCount(2)+GetTeamClientCount(3)) == 0)
        {
                GameEnded = 0;
                PrintToChatAll("No active players, server is resetting");
               
                Load_New_Map()
        }
}
 
public OnClientPutInServer(client){
		if(IsClientSourceTV(client) || IsClientReplay(client) || IsFakeClient(client)) return;
		
		// game_mode = 0: AI
		// game_mode = 1: AP
		// game_mode = 2: SOLO
		if(GetConVarInt(game_mode) == 0){
			if(GetTeamClientCount(2) >= 5)
			{
					FakeClientCommand(client, "jointeam spec");
					//ChangeClientTeam(client,1);
			}
			/*
			else if(GetTeamClientCount(2) < 5){
					FakeClientCommand(client, "jointeam good");
					//ChangeClientTeam(client,2);
			}
			*/
		}
		
		if(GetConVarInt(game_mode) == 1){
			if((GetTeamClientCount(2)+GetTeamClientCount(3)) >= 10)
			{
					FakeClientCommand(client, "jointeam spec");
					//ChangeClientTeam(client,1);
			}
			/*
			else if(GetTeamClientCount(2) < 5){
					//ChangeClientTeam(client,3);
					FakeClientCommand(client, "jointeam good");
					//ChangeClientTeam(client,2);
			}else{
					//ChangeClientTeam(client,3);
					FakeClientCommand(client, "jointeam bad");
					//ChangeClientTeam(client,3);
			}
			*/
		}
		
		if(GetConVarInt(game_mode) == 2){
			if((GetTeamClientCount(2)+GetTeamClientCount(3)) >= 2)
			{
					FakeClientCommand(client, "jointeam spec");
					//ChangeClientTeam(client,1);
			}
			/*
			else if(GetTeamClientCount(2) < GetTeamClientCount(3)){
					FakeClientCommand(client, "jointeam good");
					//ChangeClientTeam(client,2);
			}else{
					FakeClientCommand(client, "jointeam bad");
					//ChangeClientTeam(client,3);
			}
			*/
		}
        //PrintToServer("Radiant: %i Dire: %i",GetTeamClientCount(2),GetTeamClientCount(3));
}