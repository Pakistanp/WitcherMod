#include <sourcemod>

#pragma semicolon 1

new const String:Class[12][] ={
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
"Fringilla"
};

new const String:Hints[12][]={
" \x05Chcesz więcej porad? Wpisz \x03/porada.",
" \x05Aby przeczytać opisy klas wpisz \x03/klasy.",
" \x05Informacje na temat statystyk znajdziesz pod komedą \x03/staty.",
" \x05Aby zobaczyć obecnie rozdane statystyki wpisz \x03/postac.",
" \x05Czy wiesz, że co każde 5 minut spędzone na serwerze dostajesz dodatkowego expa? Wpisz \x03/time.",
" \x05Czy wiesz, że im więcej graczy na serwerze tym większy jest exp?",
" \x05Serie zabójstw dają dodatkowe punkty doświadczenia!",
" \x05Ilość doświadczenia jakie dostajesz zależy również od średniego poziomu na serwerze!",
" \x05Dostajesz dodatkowe doświadczenie za granie unikalną klasa (jedna osoba +30%, dwie +10%).",
" \x05Aby zbindowac skilla pod klawisz wpisz w konsoli \x03bind <klawisz> \"useskill\".",
" \x05Do wyrzucenia itemu użyj komendy \x03/dropi.",
" \x05Aby sprawdzić działanie itemu wpisz \x03/item."
};

new Handle:ClientInSeverTimer[MAXPLAYERS+1] = INVALID_HANDLE;

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
	RegConsoleCmd("stats", Command_Stats);
	RegConsoleCmd("staty", Command_Stats);
	RegConsoleCmd("statystyki", Command_Stats);
	RegConsoleCmd("porada", Command_Hint);
}

public void OnClientPutInServer(int client)
{
	if (IsClientInGame(client) && !IsFakeClient(client)) 
		ClientInSeverTimer[client] = (CreateTimer(300.0, HintTimer, client, TIMER_REPEAT));
}

public OnClientDisconnect(client)
{
	if (IsClientInGame(client) && !IsFakeClient(client)) 
		CloseHandle(ClientInSeverTimer[client]);
}

public Action Command_Classes(int client, int args)
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
	return Plugin_Handled;
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
					Format(buffer, sizeof(buffer), "          Opis Klasy Lambert \n \n• 100 HP \n• Posiada znak Igni który atakuje obszarowo zadaje duże obrażenia, ale ma mały zasieg.\nIgni ma szanse na podpalenie wroga.\n• Zasięg: 300 + int\n• Obrażenia: 15% hp + int * 0.5\n• Szansa na podpalenie [%%]: 20 + int/6.6, max 50\n• Czas podpalenia: 3 sek\n• Cooldown: 20 sek\n");
					PanelInfo(client, buffer);
				}	
				case 1:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "          Opis Klasy Geralt \n \n• 110 HP \n• Posiada znak Aard który odpycha i atakuje wrogów obszarowo, zadaje małe obrażenia, ma średni zasieg.\nAard ma szanse na wyrzucenie broni.\n• Zasięg: 400 + int * 1.25\n• Obrażenia: 10% hp + int * 0.25\n• Szansa na wyrzucenie broni [%]: 20 + int/6.6, max 50\n• Cooldown: 20 sek\n");
					PanelInfo(client, buffer);
				}
				case 2:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "          Opis Klasy Vesemir \n \n• 120 HP \n• Posiada znak Yrden który, spowalnia wrogów na średnim dystansie.\n• Zadaje nieuchronne dodatkowe obrażenia spowolnionym wrogom.\n• Dodatkowe obrażenia: 2 + int/10\n• Zasięg: 400 + int * 1.25\n• Spowolnienie [%%]: 10 + int * 0.25, max 60\n• Czas spowolnienia: 3 + int / 50 sek (max 8)\n• Cooldown: 20 sek\n");
					PanelInfo(client, buffer);
				}
				case 3:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "          Opis Klasy Eskel \n \n• 100 HP \n• Posiada znak Queen który daje magiczna tarcze pochlaniajaca obrażenia.\nKiedy tarcza zostaje zniszczona odrzuca wrogów na małym dystansie i wybucha zadajac małe obrazenia.\n• Moc tarczy (HP): 20 + int\n• Obrażenia od wybuchu: 5% hp + int * 0.15\n• Zasieg wybuchu: 200 + int\n• Cooldown: 20sek\n");
					PanelInfo(client, buffer);
				}
				case 4:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "          Opis Klasy Leto \n \n• 115 HP \n• Posiada znak Aksji zwiekszający szanse oraz obrażenia od trafień krytycznych.\n• Aksji jest aktywne cały czas.\n• Szansa na krytyczne trafienie [%%]: 10 + int/25, max 20\n• Krytyczne obrażenia [%%]: 20 + int/2 , max 200\n");
					PanelInfo(client, buffer);
				}
				case 5:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "          Opis Klasy Ciri(klasa jeszcze nie skonczona) \n \n• 125 HP \n• Posiada teleport aby uzyc wybierz noz i PPM.\n• Zasięg teleportu: 600 + int * 2\n");
					PanelInfo(client, buffer);
				}
				case 6:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "          Opis Klasy Yennefer \n \n• 90 HP \n• Posiada czar klatwy ktory atakuje najblizszego wroga w zasiegu.\n• Obrażenia: 20% hp + int.\n• Zasięg: 600 + int * 2\n");
					PanelInfo(client, buffer);
				}
				case 7:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "          Opis Klasy Triss \n \n• 105 HP \n• Posiada czar kula ognia.\n• Kula po zderzeniu wybucha w obszarze 150 zadajac obrazenia.\n• Obrażenia: 15% hp + int/2 \n");
					PanelInfo(client, buffer);
				}
				case 8:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "          Opis Klasy Keira \n \n• 110 HP \n• Kiedy stoi bez ruchu i trzyma nóż jest niewidzialna.\n• Dostaje decoy na poczatku rundy.\n• Decoy ma model gracza.\n• Ilosc decoy na runde: 1 + int/50 \n• Niewidzialnosc [%%]: 50 - int/5, max 90\n");
					PanelInfo(client, buffer);
				}
				case 9:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "          Opis Klasy Felippa \n \n• 100 HP \n• Może wskrzeszac sojuszników przyrzymując E.\n• Co 5 sek leczy siebie albo sojuszników w zależnosci od opcji.\n• Opcje można zmienić używając skilla(useskill).\n• Leczenie: 5 + int/10 \n");
					PanelInfo(client, buffer);
				}
				case 10:
				{
					char buffer[512];
					Format(buffer, sizeof(buffer), "          Opis Klasy Fringilla \n \n• 110 HP \n• Zamienia najblizszego gracza w kurczaka na 3sek\n• Przejmuje moce postaci na 10 + int/15 sek.\n• Pozyskane moce sa silniejsze i zależą od int.\n");
					PanelInfo(client, buffer);
				}
			}
		}
		case MenuAction_End:
			delete menu;
	}
	return 0;
}

public Action PanelInfo(client, char msg[512])
{
    Panel panels = new Panel();
    panels.SetTitle(msg);
    panels.DrawItem("Zamknij");
 
    panels.Send(client, BlankHelp, 30);
    delete panels;
 
    return Plugin_Handled;
}

public int BlankHelp(Menu menu, MenuAction action, int param1, int param2)
{
}

public Action Command_Stats(int client, int args)
{	
	char buffer[512];
	Format(buffer, sizeof(buffer), "          Opis Statystyk \n \n• Inteligencja:  zwiększa moc skilli(obrazenia, zasieg itp.)\n• Siła: + 2hp co każdy punkt\n• Zręczność: zmniejsza otrzymywanie obrażenia fizyczne (max 50%). Ma wpływ na wytrzymałośc przedmiotów\n• Zwinnosc: zwieksza predkość gracza (max 50%)\n mniejsza otrzymywane obrazenia magiczne (max 70%)\n");
	PanelInfo(client, buffer);
	return Plugin_Handled;
}

public Action Command_Hint(int client, int args)
{	
	PrintToChat(client, "%s",Hints[GetRandomInt(1,11)]);
	return Plugin_Handled;
}
public Action:HintTimer(Handle:timer, any:client)
{
	Command_Hint(client, 1);
	PrintToChat(client, "%s",Hints[0]);
}