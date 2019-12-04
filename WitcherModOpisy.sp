#include <sourcemod>

#pragma semicolon 1

new const String:Class[17][] ={
"Brak",
"Lambert",
"Geralt",
"Vesemir",
"Eskel",
"Leto",
"Ciri",
"Yennefer",
"Triss",
"Keira",
"Felippa",
"Fringilla",
"Ge'els",
"Imlerith",
"Caranthir",
"Nithral",
"Eredin"
};

new const String:Hints[14][]={
"Hint0",
"Hint1",
"Hint2",
"Hint3",
"Hint4",
"Hint5",
"Hint6",
"Hint7",
"Hint8",
"Hint9",
"Hint10",
"Hint11",
"Hint12",
"Hint13"
};

new Handle:ClientInSeverTimer[MAXPLAYERS+1] = INVALID_HANDLE;

bool g_bMessagesShown[MAXPLAYERS + 1];

public Plugin myinfo = {
	name = "WitcherModOpisy",
	author = "Z-Boku",
	description = "Opisy do WitcherMod",
	version = "1.0.0.0",
	url = "https://steamcommunity.com/profiles/76561198042001813/"
};

public void OnPluginStart()
{
	RegConsoleCmd("klasy", Command_Classes);
	RegConsoleCmd("classes", Command_Classes);
	RegConsoleCmd("stat", Command_Stats);
	RegConsoleCmd("staty", Command_Stats);
	RegConsoleCmd("statystyki", Command_Stats);
	RegConsoleCmd("porada", Command_Hint);
	RegConsoleCmd("hint", Command_Hint);
	RegConsoleCmd("sm_language", Command_Language);
	RegConsoleCmd("sm_lang", Command_Language);
	RegConsoleCmd("sm_jezyk", Command_Language);
	
	HookEvent("player_spawn", Event_OnPlayerSpawn);
	
	LoadTranslations("witchermoddesc.phrases");
}

public void OnClientPutInServer(int client)
{
	if (IsClientInGame(client) && !IsFakeClient(client)) 
	{
		if (GetClientLanguage(client) != GetLanguageByCode("pl"))
			SetClientLanguage(client, GetLanguageByCode("en"));
		ClientInSeverTimer[client] = (CreateTimer(300.0, HintTimer, client, TIMER_REPEAT));
	}
}

public OnClientDisconnect(client)
{
	if (IsClientInGame(client) && !IsFakeClient(client)) 
		CloseHandle(ClientInSeverTimer[client]);
		
	g_bMessagesShown[client] = false;
}

public void OnMapStart()
{
	for (int i = 1; i <= MaxClients; i++)
	{
		g_bMessagesShown[i] = false;
	}
}

public void Event_OnPlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	if (client == 0 || IsFakeClient(client))
	{
		return;
	}
	
	CreateTimer(0.2, Timer_DelaySpawn, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_DelaySpawn(Handle timer, any data)
{
	int client = GetClientOfUserId(data);
	
	if (client == 0 || !IsPlayerAlive(client) || g_bMessagesShown[client])
	{
		return Plugin_Continue;
	}

	new String:sWebsiteLink[] = "http://witchermod.gameclan.pl/forum/";

	PrintToChat(client, "%T", "Welcome", client, 0x07, 0x01, 0x06, client);
	PrintToChat(client, "%T", "JoinToCommunity", client, 0x07, 0x01, 0x06, sWebsiteLink);
	PrintToChat(client, "%T", "ToChooseClass", client, 0x07, 0x01, 0x06);
	PrintToChat(client, "%T", "ToChangeLang", client, 0x07, 0x01, 0x06, 0x07);
	g_bMessagesShown[client] = true;
	
	return Plugin_Continue;
}

public Action Command_Classes(int client, int args)
{	
	Classess(client);
	return Plugin_Handled;
}

public Classess(int client)
{
	Menu menu = new Menu(MenuClasses_Handler);
	menu.SetTitle("Opisy klas\n \n");
	for(int i = 1; i < sizeof(Class); i++)
	{
		new String:item[64];
		Format(item, sizeof(item), "%s", Class[i]);
		menu.AddItem(NULL_STRING, item);
	}
	menu.Display(client, 60);
}
public int MenuClasses_Handler(Menu menu, MenuAction action, int client, int a)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch(a)
			{
				case 0:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "%t", "Lambert");
					PanelInfoClass(client, buffer);
				}	
				case 1:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "%t", "Geralt");
					PanelInfoClass(client, buffer);
				}
				case 2:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "%t", "Vesemir");
					PanelInfoClass(client, buffer);
				}
				case 3:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "%t", "Eskel");
					PanelInfoClass(client, buffer);
				}
				case 4:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "%t", "Leto");
					PanelInfoClass(client, buffer);
				}
				case 5:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "%t", "Ciri");
					PanelInfoClass(client, buffer);
				}
				case 6:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "%t", "Yennefer");
					PanelInfoClass(client, buffer);
				}
				case 7:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "%t", "Triss");
					PanelInfoClass(client, buffer);
				}
				case 8:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "%t", "Keira");
					PanelInfoClass(client, buffer);
				}
				case 9:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "%t", "Felippa");
					PanelInfoClass(client, buffer);
				}
				case 10:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "%t", "Fringilla");
					PanelInfoClass(client, buffer);
				}
				case 11:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "%t", "Ge'els");
					PanelInfoClass(client, buffer);
				}
				case 12:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "%t", "Imlerith");
					PanelInfoClass(client, buffer);
				}
				case 13:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "%t", "Caranthir");
					PanelInfoClass(client, buffer);
				}
				case 14:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "%t", "Nithral");
					PanelInfoClass(client, buffer);
				}
				case 15:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "%t", "Eredin");
					PanelInfoClass(client, buffer);
				}
			}
		}
		case MenuAction_End:
			delete menu;
	}
	return 0;
}

public Action PanelInfoClass(client, char msg[512])
{
	char buffer[10];
	Format(buffer, sizeof(buffer), "%t", "Back");
	
	Panel panels = new Panel();
	panels.SetTitle(msg);
	panels.DrawItem(buffer);
	Format(buffer, sizeof(buffer), "%t", "Exit");
	panels.DrawItem(buffer);
 
	panels.Send(client, BlankHelp, 30);
	delete panels;
 
	return Plugin_Handled;
}

public int BlankHelp(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select && param2 == 1)
	{
		Classess(param1);
	}
}

public Action Command_Stats(int client, int args)
{	
	char buffer[512];
	Format(buffer, sizeof(buffer), "%t", "Stats");
	PanelInfoClass(client, buffer);
	return Plugin_Handled;
}

public Action Command_Hint(int client, int args)
{	
	PrintToChat(client, "%T", Hints[GetRandomInt(1,13)], client, 0x05, 0x06);
	return Plugin_Handled;
}
public Action:HintTimer(Handle:timer, any:client)
{
	Command_Hint(client, 1);
	PrintToChat(client, "%T", Hints[0], client, 0x05, 0x06);
}

public Action Command_Language(int client, int args)
{	
	char full[256];
 
	GetCmdArgString(full, sizeof(full));
	if (StrEqual(full, "pl") || StrEqual(full, "en"))
	{
		SetClientLanguage(client, GetLanguageByCode(full));
		PrintToChat(client, "%T", "LangChange", client, 0x05, 0x06, full);
	}
	else
	{
		PrintToChat(client, "%T", "LangNotAvailable", client, 0x05, 0x06, full);
		PrintToChat(client, " \x06en, pl");
	}
			
	return Plugin_Handled;
}