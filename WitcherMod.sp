#include <sourcemod>
#include <sdktools>
#include <sdkhooks> 
#include <cstrike>
#include <morecolors>

#pragma tabsize 0

#define SQLTABLE "table_witchermod"
#define BASEEXP 1000.0

#define IGNICOLOR	{89,35,13,200}
#define AARDCOLOR	{0,50,100,200}
#define YRDENCOLOR	{41,16,38,200}
#define QUEENCOLOR	{100,87,0,200}

#define MODEL_LIGHTNING	"materials/sprites/purplelightning.vmt"
#define MODEL_MINE "models/tripmine/tripmine.mdl"

#define SOUND_FREEZE "physics/glass/glass_impact_bullet4.wav"

#define FFADE_IN 0x0001 // Just here so we don't pass 0 into the function
#define FFADE_OUT 0x0002 // Fade out (not in)
#define FFADE_MODULATE 0x0004 // Modulate (don't blend)
#define FFADE_STAYOUT 0x0008 // ignores the duration, stays faded out until new ScreenFade message received
#define FFADE_PURGE 0x0010 // Purges all other fades, replacing them with this one

new const LevelXP[] = {
	0,
	48, 144, 302, 536, 811, 1229, 1688, 2271, 2917, 3700, 
	4509, 5402, 6345, 7462, 8605, 9803, 11078, 12418, 13835, 15323, 
	16982, 18655, 20427, 22290, 24239, 26303, 28463, 30679, 32905, 35286, 
	37762, 40309, 42918, 45636, 48404, 51283, 54181, 57116, 60200, 63306, 
	66465, 69671, 72947, 76270, 79741, 83237, 86738, 90470, 94237, 98170, 
	102176, 106322, 110529, 114794, 119149, 123526, 128010, 132544, 137192, 141989, 
	146837, 151762, 156797, 161871, 167051, 172302, 177638, 183007, 188513, 194102, 
	199734, 205370, 211106, 216851, 222690, 228610, 234703, 240858, 247127, 253476, 
	259852, 266360, 272917, 279521, 286216, 292953, 299701, 306622, 313552, 320520, 
	327751, 335043, 342366, 349825, 357399, 365063, 372819, 380603, 388443, 396356, //100
	404364, 412412, 420632, 428945, 437289, 445762, 454316, 462910, 471557, 480260, 
	488997, 497948, 506931, 515997, 525120, 534375, 543675, 553105, 562580, 572105, 
	581777, 591528, 601345, 611189, 621039, 631050, 641118, 651186, 661470, 671852, 
	682312, 692867, 703455, 714151, 724882, 735638, 746417, 757358, 768359, 779390, 
	790664, 801996, 813358, 824741, 836193, 847832, 859585, 871395, 883225, 895106, 
	907038, 919114, 931285, 943541, 955874, 968304, 980747, 993372, 1006082, 1018809, 
	1031555, 1044358, 1057165, 1070029, 1082996, 1096090, 1109211, 1122516, 1135979, 1149535, 
	1163148, 1176776, 1190439, 1204163, 1217911, 1231765, 1245704, 1259875, 1274057, 1288438, 
	1302830, 1317348, 1331911, 1346581, 1361321, 1376195, 1391098, 1406083, 1421132, 1436225, 
	1451442, 1466733, 1482169, 1497680, 1513235, 1528797, 1544374, 1560003, 1575876, 1591764, //200
	1607825, 1623966, 1640143, 1656350, 1672561, 1688964, 1705370, 1721952, 1738631, 1755392, 
	1772234, 1789141, 1806141, 1823218, 1840404, 1857667, 1874986, 1892403, 1909896, 1927447, 
	1945032, 1962734, 1980457, 1998187, 2015939, 2033969, 2052044, 2070184, 2088382, 2106752, 
	2125194, 2143707, 2162221, 2180767, 2199418, 2218171, 2237126, 2256120, 2275220, 2294382, 
	2313654, 2332939, 2352241, 2371725, 2391250, 2410819, 2430528, 2450247, 2470098, 2489984, 
	2510032, 2530128, 2550240, 2570509, 2590853, 2611226, 2631607, 2652049, 2672710, 2693422, 
	2714148, 2735045, 2755976, 2777066, 2798179, 2819348, 2840570, 2861905, 2883323, 2904893, 
	2926561, 2948275, 2970075, 2991984, 3013977, 3035984, 3058081, 3080303, 3102579, 3124920, 
	3147360, 3169888, 3192448, 3215144, 3237880, 3260618, 3283536, 3306484, 3329480, 3352588, 
	3375730, 3398919, 3422245, 3445757, 3469276, 3492811, 3516494, 3540259, 3564121, 3588118, //300
	3612157, 3636218, 3660361, 3684542, 3708832, 3733157, 3757648, 3782148, 3806723, 3831313, 
	3856127, 3881055, 3906047, 3931094, 3956154, 3981227, 4006526, 4031956, 4057402, 4082990, 
	4108585, 4134271, 4160082, 4185997, 4211915, 4237839, 4263921, 4290095, 4316413, 4342767, 
	4369130, 4395515, 4422011, 4448657, 4475422, 4502278, 4529140, 4556151, 4583246, 4610373, 
	4637579, 4664899, 4692235, 4719676, 4747170, 4774829, 4802580, 4830387, 4858290, 4886260, 
	4914257, 4942324, 4970549, 4998841, 5027175, 5055594, 5084013, 5112604, 5141312, 5170030, 
	5198787, 5227577, 5256375, 5285433, 5314503, 5343639, 5372785, 5401944, 5431463, 5460985, 
	5490554, 5520178, 5549966, 5579798, 5609746, 5639773, 5669855, 5700042, 5730337, 5760645, 
	5790976, 5821446, 5852000, 5882574, 5913326, 5944107, 5974985, 6005885, 6036978, 6068149, 
	6099424, 6130739, 6162159, 6193650, 6225215, 6256858, 6288522, 6320239, 6351981, 6383938, //400
	6415999, 6448111, 6480271, 6512510, 6544767, 6577075, 6609606, 6642194, 6674808, 6707577, 
	6740443, 6773315, 6806229, 6839224, 6872284, 6905555, 6938868, 6972199, 7005540, 7038934, 
	7072426, 7105967, 7139771, 7173629, 7207566, 7241593, 7275676, 7309811, 7343982, 7378346, 
	7412785, 7447300, 7481832, 7516412, 7551093, 7585848, 7620756, 7655762, 7690868, 7725994, 
	7761236, 7796584, 7831969, 7867449, 7903014, 7938598, 7974224, 8009857, 8045692, 8081567, 
	8117614, 8153724, 8189837, 8226014, 8262211, 8298665, 8335145, 8371632, 8408336, 8445110, 
	8481986, 8518910, 8555900, 8593007, 8630153, 8667404, 8704746, 8742142, 8779548, 8816968, 
	8854640, 8892354, 8930166, 8968065, 9006029, 9044106, 9082203, 9120364, 9158582, 9196842, 
	9235114, 9273651, 9312237, 9350910, 9389643, 9428416, 9467258, 9506182, 9545221, 9584291, 
	9623494, 9662812, 9702224, 9741709, 9781198, 9820735, 9860409, 9900221, 9940058, 9979940, //500
	10019941, 10059974, 10100159, 10140471, 10180845, 10221306, 10261862, 10302424, 10343049, 10383720, 
	10424520, 10465328, 10506329, 10547419, 10588532, 10629660, 10670911, 10712256, 10753735, 10795215, 
	10836740, 10878344, 10919977, 10961614, 11003574, 11045542, 11087689, 11129849, 11172052, 11214322, 
	11256621, 11299097, 11341675, 11384296, 11427010, 11469797, 11512595, 11555615, 11598699, 11641859, 
	11685120, 11728459, 11771801, 11815154, 11858690, 11902284, 11945905, 11989584, 12033501, 12077499, 
	12121527, 12165638, 12209760, 12254075, 12298465, 12342898, 12387409, 12432000, 12476601, 12521234, 
	12566011, 12610905, 12655912, 12700935, 12746037, 12791174, 12836399, 12881635, 12927071, 12972636, 
	13018312, 13064054, 13109809, 13155588, 13201537, 13247558, 13293632, 13339845, 13386080, 13432362, 
	13478652, 13525073, 13571525, 13618171, 13664867, 13711690, 13758646, 13805676, 13852770, 13899908, 
	13947056, 13994353, 14041687, 14089099, 14136547, 14184173, 14231917, 14279675, 14327441, 14375311, 
	14423371, 14471511, 14519721, 14567958, 14616202, 14664594, 14713099, 14761662, 14810274, 14859049, 
	14907848, 14956792, 15005811, 15054832, 15103974, 15153192, 15202527, 15251918, 15301362, 15350948, 
	15400622, 15450347, 15500115, 15550024, 15600013, 15650060, 15700131, 15750303, 15800564, 15850919, 
	15901362, 15951921, 16002533, 16053204, 16103930, 16154795, 16205672, 16256590, 16307592, 16358680, 
	16409806, 16460975, 16512160, 16563426, 16614763, 16666181, 16717780, 16769470, 16821267, 16873199, 
	16925210, 16977264, 17029403, 17081591, 17133990, 17186389, 17238803, 17291240, 17343791, 17396543, 
	17449417, 17502346, 17555302, 17608342, 17661457, 17714599, 17767864, 17821301, 17874751, 17928259, 
	17981896, 18035580, 18089284, 18143113, 18197010, 18251056, 18305170, 18359367, 18413612, 18467868, 
	18522303, 18576783, 18631266, 18685924, 18740705, 18795493, 18850296, 18905270, 18960264, 19015295, 
	19070386, 19125479, 19180800, 19236164, 19291685, 19347352, 19403067, 19458836, 19514622, 19570478, 
	19626428, 19682416, 19738546, 19794708, 19851053, 19907488, 19964000, 20020617, 20077239, 20134027, 
	20190835, 20247662, 20304699, 20361805, 20418970, 20476197, 20533452, 20590834, 20648303, 20705800, 
	20763436, 20821100, 20878887, 20936776, 20994742, 21052764, 21110848, 21168932, 21227026, 21285385, 
	21343795, 21402262, 21460825, 21519440, 21578062, 21636848, 21695790, 21754786, 21813817, 21872874, 
	21932121, 21991393, 22050738, 22110213, 22169690, 22229265, 22288900, 22348545, 22408276, 22468155, 
	22528035, 22588108, 22648183, 22708482, 22768846, 22829237, 22889655, 22950233, 23010941, 23071719, 
	23132512, 23193332, 23254222, 23315300, 23376467, 23437682, 23498898, 23560261, 23621656, 23683134, 
	23744729, 23806487, 23868276, 23930194, 23992126, 24054200, 24116334, 24178495, 24240774, 24303146, 
	24365602, 24428127, 24490718, 24553351, 24616117, 24678905, 24741706, 24804597, 24867544, 24930689, 
	24993968, 25057267, 25120600, 25184045, 25247557, 25311077, 25374660, 25438435, 25502282, 25566281, 
	25630308, 25694367, 25758580, 25822888, 25887213, 25951585, 26016012, 26080600, 26145302, 26210087, 
	26274925, 26339811, 26404798, 26469917, 26535096, 26600333, 26665655, 26731030, 26796407, 26861876, 
	26927496, 26993194, 27058914, 27124643, 27190582, 27256563, 27322596, 27388652, 27454771, 27521082, 
	27587402, 27653948, 27720495, 27787117, 27853826, 27920642, 27987464, 28054484, 28121552, 28188743, 
	28255964, 28323255, 28390642, 28458034, 28525481, 28592951, 28660653, 28728432, 28796214, 28864057, 
	28931961, 29000001, 29068132, 29136412, 29204805, 29273217, 29341714, 29410318, 29478972, 29547741, 
	29616620, 29685514, 29754432, 29823516, 29892679, 29961932, 30031244, 30100612, 30170022, 30239542, 
	30309129, 30378813, 30448508, 30518407, 30588392, 30658383, 30728468, 30798596, 30868814, 30939055, 
	31009299, 31079859, 31150455, 31221084, 31291738, 31362518, 31433341, 31504287, 31575253, 31646388, 
	31717558, 31788864, 31860180, 31931548, 32003033, 32074555, 32146247, 32217977, 32289771, 32361607, 
	32433500, 32505475, 32577647, 32649844, 32722067, 32794428, 32866871, 32939359, 33011915, 33084612, 
	33157416, 33230260, 33303158, 33376222, 33449343, 33522578, 33595917, 33669336, 33742785, 33816316, 
	33889938, 33963655, 34037433, 34111258, 34185180, 34259231, 34333299, 34407523, 34481774, 34556037, 
	34630499, 34705036, 34779658, 34854322, 34929101, 35003880, 35078791, 35153707, 35228746, 35303796, 
	35379062, 35454339, 35529620, 35604995, 35680578, 35756256, 35832003, 35907804, 35983679, 36059557, 
	36135503, 36211644, 36287822, 36364105, 36440440, 36516900, 36593426, 36669971, 36746675, 36823397, 
	36900217, 36977039, 37054008, 37131066, 37208253, 37285484, 37362740, 37440032, 37517509, 37595013, 
	37672616, 37750375, 37828201, 37906111, 37984088, 38062124, 38140273, 38218506, 38296823, 38375214, 
	38453636, 38532118, 38610614, 38689180, 38767917, 38846688, 38925547, 39004415, 39083465, 39162534, 
	39241760, 39320997, 39400346, 39479842, 39559400, 39639019, 39718757, 39798545, 39878421, 39958397
}

new const String:Class[14][] ={
"Brak",
"Lambert",
"Geralt",
"Vesemir",
"Eskel",
"Leto",
"Ciri(Vip) - wkrótce",
"Yennefer",
"Triss",
"Keira",
"Felippa",
"Fringilla(Vip)",
"Ge'els",
"Imlerith"
}
new const ClassHP[14] = {
100,
100,
110,
120,
100,
115,
125,
90,
105,
110,
100,
110,
100,
120
}
new playerVip[MAXPLAYERS+1];
new playerExp[MAXPLAYERS+1] = {1, ...};
new playerLevel[MAXPLAYERS+1] = {1, ...};
new bool:playerToSetPoints[MAXPLAYERS+1] = {false, ...};
new playerClass[MAXPLAYERS+1] = {0, ...};
new playerHP[MAXPLAYERS+1] = {100, ...};
new playerClassLevel[MAXPLAYERS+1][14];

new playerStrength[MAXPLAYERS+1] = {0, ...};
new playerIntelligence[MAXPLAYERS+1] = {0, ...};
new playerDexterity[MAXPLAYERS+1] = {0, ...};
new playerAgility[MAXPLAYERS+1] = {0, ...};
new playerPoints[MAXPLAYERS+1] = {0, ...};

float playerDamageReduction[MAXPLAYERS+1];
float playerMagicDamageReduction[MAXPLAYERS+1];
float playerSpeed[MAXPLAYERS+1] = {0.0, ...};
float playerCooldown[MAXPLAYERS+1];
new playerChanceToCrit[MAXPLAYERS+1];
float playerCritDamage[MAXPLAYERS+1];
new playerChanceToBurnSkill[MAXPLAYERS+1];
new playerChanceToDropWpnSkill[MAXPLAYERS+1];
new playerMagicHP[MAXPLAYERS+1];
new playerMagicHPMax[MAXPLAYERS+1];
new playerAdditionalDamageSlow[MAXPLAYERS+1];
new playerInvisibility[MAXPLAYERS+1];
new playerHeal[MAXPLAYERS+1];
new playerReflectDamage[MAXPLAYERS+1];
new playerDamageToReflect[MAXPLAYERS+1];
new playerChanceToBleed[MAXPLAYERS+1];
new playerBleedDamage[MAXPLAYERS+1];
new playerChanceToRefillAmmo[MAXPLAYERS+1];

new isReflectionDamage[MAXPLAYERS+1];
new playerDecoyMaxCount[MAXPLAYERS+1];
new playerIsInvisible[MAXPLAYERS+1];
new bool:playerMove[MAXPLAYERS+1];
new bool:playerIsChicken[MAXPLAYERS+1] = {false, ...};
new String:playerModel[MAXPLAYERS+1][64];
new bool:playerIsBleed[MAXPLAYERS+1] = {false, ...};
new playerBleedBy[MAXPLAYERS+1]= {-1, ...};

new playerMinutes[MAXPLAYERS+1] = {0, ...};
new playerKillsSeries[MAXPLAYERS+1] = {0, ...};
new String:playerSid[MAXPLAYERS+1][64];
new playerOldId[MAXPLAYERS+1];

new playerExpLastRound[MAXPLAYERS+1];
new String:playerKillNamesLastRound[MAXPLAYERS+1][MAXPLAYERS+1][64];
new playerKillExpLastRound[MAXPLAYERS+1][MAXPLAYERS+1];
new playerKillLastRoundCount[MAXPLAYERS+1];

new playerIgnitedBy[MAXPLAYERS+1] = {0, ...};
new bool:isPlayerSlowed[MAXPLAYERS+1];

new playerHealOption[MAXPLAYERS+1];

int revivingTarget[MAXPLAYERS + 1];
new decoyEntity[MAXPLAYERS + 1] = {-1, ...};

new g_iClip1 = -1;
new g_hActiveWeapon = -1;

new g_FreezeSprite;

new g_PlayerPrimaryAmmo[MAXPLAYERS+1] = {0, ...};
new g_PlayerSecondaryAmmo[MAXPLAYERS+1] = {0, ...};

enum Slots
{
	Slot_Primary,
	Slot_Secondary,
	Slot_Knife,
	Slot_Grenade,
	Slot_C4,
	Slot_None
};

new skillColor[5][4] = {
{0,0,0,0},
IGNICOLOR,
AARDCOLOR,
YRDENCOLOR,
QUEENCOLOR
}
new avgLevel;
//new fLastButtons[MAXPLAYERS+1];
new fLastFlags[MAXPLAYERS+1];
new String:DamageEventName[16];
new damageShow[MAXPLAYERS+1];
new bool:blockShowDamageTimer[MAXPLAYERS + 1] = {false,...};

new bool:isMenuPointsDisplayed[MAXPLAYERS+1];
new bool:playerBasePropertyLoaded[MAXPLAYERS+1];

new String:skillHud[MAXPLAYERS+1][20];
new String:hudOption[MAXPLAYERS+1][10];
new Handle:g_hHudSync;
new Handle:handleMenuPoints[MAXPLAYERS+1] = INVALID_HANDLE;
new Handle:handleSetAbilityTimer[MAXPLAYERS+1] = INVALID_HANDLE;
new Handle:ClientInSeverTimer[MAXPLAYERS+1] = INVALID_HANDLE;
//new Handle:handleCooldownTimer[MAXPLAYERS+1] = INVALID_HANDLE;
Handle g_hReviving[MAXPLAYERS + 1];
Handle healHandle[MAXPLAYERS + 1];

// SQL //

new Handle:DB = INVALID_HANDLE;

new g_beamsprite, g_halosprite;

new entLighting[MAXPLAYERS+1];

//ITEMS
new playerItem[MAXPLAYERS+1];
new String:playerItemName[MAXPLAYERS+1][64];
new itemEndurance[MAXPLAYERS+1];

new playerBonusHP[MAXPLAYERS+1];
new playerBonusStrength[MAXPLAYERS+1];
new playerBonusIntelligence[MAXPLAYERS+1];
new playerBonusDexterity[MAXPLAYERS+1];
new playerBonusAgility[MAXPLAYERS+1];
new playerBonusAllStats[MAXPLAYERS+1];

float playerBonusDamageReduction[MAXPLAYERS+1];
float playerBonusMagicDamageReduction[MAXPLAYERS+1];
float playerBonusSpeed[MAXPLAYERS+1];
float playerBonusReduceCooldown[MAXPLAYERS+1];
new playerBonusChanceToCrit[MAXPLAYERS+1];
float playerBonusCritDamage[MAXPLAYERS+1];
new playerBonusChanceToBurnSkill[MAXPLAYERS+1];
new playerBonusChanceToDropWpnSkill[MAXPLAYERS+1];
new playerBonusMagicHP[MAXPLAYERS+1];
new playerBonusAdditionalDamage[MAXPLAYERS+1];
new playerBonusAdditionalDamageSlow[MAXPLAYERS+1];
new playerBonusReduction[MAXPLAYERS+1];
new playerBonusChanceToRespawn[MAXPLAYERS+1];
new playerBonusAdditionalDamageKnife[MAXPLAYERS+1];
new playerBonusVampire[MAXPLAYERS+1];
new playerBonusGravity[MAXPLAYERS+1];
new playerBonusSlow[MAXPLAYERS+1];

new playerBonusIgni[MAXPLAYERS+1];
new playerBonusAard[MAXPLAYERS+1];
new playerBonusYrden[MAXPLAYERS+1];
new playerBonusQueen[MAXPLAYERS+1];
new playerBonusAksji[MAXPLAYERS+1];
new playerBonusTeleport[MAXPLAYERS+1];
new playerBonusFireBall[MAXPLAYERS+1];
new playerBonusCurse[MAXPLAYERS+1];
new playerBonusInvisible[MAXPLAYERS+1];
new playerBonusReviving[MAXPLAYERS+1];

float playerBonusIgniDamage[MAXPLAYERS+1];
float playerBonusAardDamage[MAXPLAYERS+1];
float playerBonusYrdenDamage[MAXPLAYERS+1];
float playerBonusQueenDamage[MAXPLAYERS+1];
float playerBonusAksjiDamage[MAXPLAYERS+1];
float playerBonusFireBallDamage[MAXPLAYERS+1];
float playerBonusCurseDamage[MAXPLAYERS+1];

public Plugin myinfo = {
	name = "WitcherMod",
	author = "Z-Boku",
	description = "WitcherMod na podstawie diablomoda",
	version = "1.0.0.0",
	url = "https://steamcommunity.com/profiles/76561198042001813/"
};

public void OnPluginStart()
{	
	new String:Error[200];
	DB = SQL_Connect("ExpMod", true, Error, sizeof(Error));
	if(DB == INVALID_HANDLE)
	{
		PrintToServer("[SQL][ERROR]Cannot connect to MySQL Server: %s", Error);
		CloseHandle(DB);
	}
	else
	{
		PrintToServer("[SQL]Connection Successful");
		SQL_Start();
	}

	g_hActiveWeapon = FindSendPropInfo("CCSPlayer", "m_hActiveWeapon");
	//g_iPrimaryAmmoType = FindSendPropInfo("CBaseCombatWeapon", "m_iPrimaryAmmoType");
	g_iClip1 = FindSendPropInfo("CBaseCombatWeapon", "m_iClip1");
	// if (g_hActiveWeapon == -1 || g_iPrimaryAmmoType == -1 || g_iAmmo == -1 || g_iClip1 == -1)
		// SetFailState("Failed to retrieve entity member offsets");
	
	RegConsoleCmd("klasa", Command_Class);
	RegConsoleCmd("class", Command_Class);
	RegConsoleCmd("reset", Command_Reset);
	RegConsoleCmd("exp", Command_Exp);
	RegConsoleCmd("czas", Command_getTime);
	RegConsoleCmd("time", Command_getTime);
	RegConsoleCmd("postac", Command_Character);
	RegConsoleCmd("dropi", Command_DropItem);
	RegConsoleCmd("item", Command_ItemInfo);
	
	RegConsoleCmd("useskill", Command_UseSkill);

	HookEvent("player_death", Event_PlayerDeath);
	// HookEvent("player_death", Event_PlayerDeathPre, EventHookMode_Pre);
	HookEvent("player_spawn", Event_PlayerSpawn);
	HookEvent("player_team", Event_PlayerChangeTeam);
	HookEvent("round_start", OnRoundStart, EventHookMode_PostNoCopy); 
	HookEvent("bomb_planted", Event_BombPlanted );
	HookEvent("bomb_defused", Event_BombDefused );
	HookEvent("decoy_started", Event_DecoyStarted );
	HookEvent("decoy_detonate", Event_DecoyDetonate );
	//HookEvent( "player_use", Event_PlayerUse );
	HookEvent("item_pickup", Event_ItemPickup);
	
	HookEvent("player_hurt", Event_PlayerHurt, EventHookMode_Post);
	DamageEventName = "dmg_health";
	
	
	// for(new iChannel = 0; iChannel < MAXPLAYERS+1; iChannel++)
	// {
		g_hHudSync = CreateHudSynchronizer();
		if(g_hHudSync == INVALID_HANDLE)
			SetFailState("HUD synchronisation is not supported by this mod");
	// }
	SetHudTextParams(0.01, -0.05, 604800.0, 204, 204, 204, 200, 0);
}

public void OnMapStart()
{
	CreateTimer(60.0, SetTimeFor);
	g_beamsprite = PrecacheModel("materials/sprites/laserbeam.vmt");
	g_halosprite = PrecacheModel("materials/sprites/halo.vmt");
	
	PrecacheModel( MODEL_LIGHTNING );
	
	AddFileToDownloadsTable( MODEL_LIGHTNING );
	AddFileToDownloadsTable( "materials/sprites/purplelightning.vtf" );
	
	PrecacheModel( MODEL_MINE );
	
	AddFileToDownloadsTable( MODEL_MINE );
	AddFileToDownloadsTable( "models/tripmine/tripmine.dx90.vtx" );
	AddFileToDownloadsTable( "models/tripmine/tripmine.mdl" );
	AddFileToDownloadsTable( "models/tripmine/tripmine.phy" );
	AddFileToDownloadsTable( "models/tripmine/tripmine.vvd" );

	AddFileToDownloadsTable( "materials/models/tripmine/minetexture.vmt" );
	AddFileToDownloadsTable( "materials/models/tripmine/minetexture.vtf" );
	
	PrecacheSound( "weapons/hegrenade/explode3.wav" );
	PrecacheSound( "weapons/hegrenade/explode4.wav" );
	PrecacheSound( "weapons/hegrenade/explode5.wav" );
	
	PrecacheSound(SOUND_FREEZE, true);
	g_FreezeSprite = PrecacheModel("sprites/blueglow2.vmt");
	
	//GlowSprite = PrecacheModel("materials/sprites/blueglow1.vmt");
	
	ForcePrecache("blood_impact_heavy");
	ForcePrecache("blood_impact_goop_heavy");
	ForcePrecache("blood_impact_red_01_chunk");
	ForcePrecache("blood_impact_headshot_01c");
	ForcePrecache("blood_impact_headshot_01b");
	ForcePrecache("blood_impact_headshot_01d");
	ForcePrecache("blood_impact_basic");
	ForcePrecache("blood_impact_medium");
	ForcePrecache("blood_impact_red_01_goop_a");
	ForcePrecache("blood_impact_red_01_goop_b");
	ForcePrecache("blood_impact_goop_medium");
	ForcePrecache("blood_impact_red_01_goop_c");
	ForcePrecache("blood_impact_red_01_drops");
	ForcePrecache("blood_impact_drops1");
	ForcePrecache("blood_impact_red_01_backspray");
}

public Action:Event_PlayerHurt(Handle:event, const String:name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	new victim = GetClientOfUserId(GetEventInt(event, "userid"));
	new damage = GetEventInt(event, DamageEventName);
	
	ShowDamage(victim, attacker, damage);
	
	return Plugin_Continue;
}
public Action:Event_DecoyStarted(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	//new entity = GetClientOfUserId(GetEventInt(event, "entityid"));
	if((playerClass[client] == 9 || playerBonusInvisible[client] > 0) && decoyEntity[client] != -1)
	{
		//decoyEntity[client]
		decoyEntity[client] = FindEntityByClassname(decoyEntity[client], "decoy_projectile")
		new owner = GetEntPropEnt(decoyEntity[client], Prop_Send, "m_hThrower")
		if (IsValidEntity(decoyEntity[client]) && owner == client)
		{
			new String:model[64];
			new Float:angles[3];
			GetClientModel(client, model, sizeof(model));
			PrecacheModel(model);
			SetEntityModel(decoyEntity[client], model);
			GetClientAbsAngles(client, angles)
			// angles[0] = 0.0;
			// angles[1] = 0.0;
			// angles[2] = 0.0;
			TeleportEntity(decoyEntity[client], NULL_VECTOR, angles, NULL_VECTOR );
		}
	}
	
	return Plugin_Continue;
}
public Action:Event_DecoyDetonate(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	decoyEntity[client] = -1;
	
	return Plugin_Continue;
}
public OnRoundStart(Handle:event, const String:name[], bool:dontBroadcast) 
{ 
	new sumLvl = 0;
    for(int i = 1; i < MaxClients; i++)
	{
		if(playerClass[i] != 0)
		{
			sumLvl += playerLevel[i];
			
			PrintToChat(i ," \x05W poprzedniej rundzie udało Ci się zdobyć \x03%d\x05 expa! (Więcej pod komenda \x03/exp\x05)", playerExpLastRound[i]);
			
			if(playerToSetPoints[i] || CheckAvailablePoints(i))
			{
				if(isMenuPointsDisplayed[i] && handleMenuPoints[i] == null)
					//KillTimer(handleMenuPoints[i]);
					
				handleMenuPoints[i] = CreateTimer(0.2, SetMenuPointsTimer, i);
				playerToSetPoints[i] = false;
			}
				
			playerCooldown[i] = 0.0;
			revivingTarget[i] = -1;
			skillHud[i] = "Gotowy";
			//CheckStats(i);
			SetHud(i);
		}
	}
	CreateTimer(5.0, ResetPlayerLastRoundExpTimer);
	
	avgLevel = RoundToFloor(float(sumLvl / GetRealClientCount()));
	PrintToChatAll(" \x05Średni poziom na serwerze to \x03%d\x05.", avgLevel);
}  

void SQL_Start()
{
	new String:query[512];
	Format(query, sizeof(query), "CREATE TABLE IF NOT EXISTS `%s`(`nick` VARCHAR(64),`ip` VARCHAR(64),`sid` VARCHAR(64),`klasa` integer(2),`lvl` integer(3) DEFAULT 1,`exp` integer(9) DEFAULT 0,`sila` integer(3) DEFAULT 0,`inte` integer(3) DEFAULT 0,`zrecznosc` integer(3) DEFAULT 0,`zwinnosc` integer(3) DEFAULT 0,`vip` integer(1) DEFAULT 0,`klucz` VARCHAR(64))", SQLTABLE);
	
	new Handle:queryH = SQL_Query(DB, query);
	
	if(queryH == INVALID_HANDLE)
	{
		new String:Error[512];
		SQL_GetError(DB, Error, sizeof(Error));
		PrintToServer("[SQL][ERROR]Cannot create table. ERROR: %s", Error);
	}
	else
	{
		PrintToServer("[SQL]Table was create successful.");
	}
	CloseHandle(queryH);
}

void SQL_CreateAllClasses(client)
{
	if(IsValidClient(client) && !IsFakeClient(client))
	{
		new String:name[64];
		new String:ip[64];
		new String:sid[64];
		
		GetClientName(client, name, sizeof(name));
		ReplaceString(name, sizeof(name), "'", "Q");
		ReplaceString(name, sizeof(name), "`", "Q");
		
		GetClientIP(client, ip, sizeof(ip));
		GetClientAuthId(client, AuthId_Engine, sid, sizeof(sid));
		
		for(int i = 1; i < sizeof(Class); i++)
		{
			playerClassLevel[client][i] = 1;
			new String:query[512];			
			Format(query, sizeof(query) ,"INSERT INTO `%s` (`nick`,`ip`,`sid`,`klasa`,`lvl`,`exp`) VALUES ('%s','%s','%s',%i,%i,%i ) ", SQLTABLE, name, ip, sid, i, 1, 1);
			SQL_TQuery(DB, SQL_OnCreateAllClasses, query);
		}
	}
}

public SQL_OnCreateAllClasses(Handle:hDriver, Handle:hResult, const String:sError[], any:iData) {

    if (hResult == INVALID_HANDLE) 
	{	
        PrintToServer("[SQL][ERROR] SQL-Query failed! Error: %s", sError);
    } 
	else 
	{
		CloseHandle(hResult);
		hResult = INVALID_HANDLE;
    }
}  

void SQL_PreLoadClass(client)
{
	new String:sid[32];
	GetClientAuthId(client, AuthId_Engine, sid, sizeof(sid));
	
	new String:query[512];
	Format(query, sizeof(query), "SELECT klasa, lvl, vip FROM %s WHERE sid='%s'", SQLTABLE, sid);
	
	SQL_TQuery(DB, SQL_OnPreLoadClass, query, client);
}

public SQL_OnPreLoadClass(Handle:hDriver, Handle:hResult, const String:sError[], any:iData) 
{
	playerBasePropertyLoaded[iData] = false;
	if(hResult != INVALID_HANDLE)
	{
		if(SQL_MoreRows(hResult))
		{
			while(SQL_MoreRows(hResult))
			{
				SQL_FetchRow(hResult);
				new i = SQL_FetchInt(hResult ,0);
				playerClassLevel[iData][i] = SQL_FetchInt(hResult ,1);
				playerVip[iData] = SQL_FetchInt(hResult ,2);
			}
			playerBasePropertyLoaded[iData] = true;
		}
		if(!playerBasePropertyLoaded[iData])
		{
			SQL_CreateAllClasses(iData);
		}
	}
	else
	{
		PrintToServer("[SQL][ERROR] SQL-Query failed! Error: %s", sError);
		CloseHandle(hResult);
		hResult = INVALID_HANDLE;
	}
}  
void SQL_LoadClass(client, class)
{
	new String:sid[32];
	GetClientAuthId(client, AuthId_Engine, sid, sizeof(sid));
	
	new String:query[512];
	// TUTAJ WSZYSTKO WCZYTAC
	Format(query, sizeof(query), "SELECT klasa, lvl, exp, sila, inte, zrecznosc, zwinnosc FROM %s WHERE sid='%s' AND klasa='%d'", SQLTABLE, sid, class);

	SQL_TQuery(DB, SQL_OnLoadClass, query, client);
}
public SQL_OnLoadClass(Handle:hDriver, Handle:hResult, const String:sError[], any:iData) 
{
	if(hResult != INVALID_HANDLE)
	{
		if(SQL_FetchRow(hResult))
		{
			playerClass[iData] = SQL_FetchInt(hResult ,0);
			playerLevel[iData] = SQL_FetchInt(hResult ,1);
			playerExp[iData] = SQL_FetchInt(hResult ,2);
			playerStrength[iData] = SQL_FetchInt(hResult ,3);
			playerIntelligence[iData] = SQL_FetchInt(hResult ,4);
			playerDexterity[iData] = SQL_FetchInt(hResult ,5);
			playerAgility[iData] = SQL_FetchInt(hResult ,6);
			
			CheckStats(iData);
			SetPlayerSpeed(iData, 1.0 + playerSpeed[iData]);
			SetPlayerHp(iData, playerHP[iData]);
			SetSpecifyStats(iData);
			CS_SetClientClanTag(iData, Class[playerClass[iData]]);
		}
		else
		{
			SQL_CreateAllClasses(iData);
		}
	}
	else
	{
		CloseHandle(hResult);
		hResult = INVALID_HANDLE;
	}
}
public SQL_SaveExp(client)
{
	if(IsValidClient(client) && !IsFakeClient(client))
	{
		new String:sid[64];
		
		GetClientAuthId(client, AuthId_Engine, sid, sizeof(sid));
		
		new String:query[512];			
		Format(query, sizeof(query) ,"UPDATE `%s` SET `lvl`='%i',`exp`='%i',`sila`='%i',`inte`='%i',`zrecznosc`='%i',`zwinnosc`='%i' WHERE `sid`='%s' AND `klasa`='%i'", SQLTABLE, playerLevel[client], playerExp[client], playerStrength[client], playerIntelligence[client], playerDexterity[client], playerAgility[client],sid,playerClass[client]);
		SQL_TQuery(DB, SQL_OnSaveExp, query);
		
	}
}
public SQL_OnSaveExp(Handle:hDriver, Handle:hResult, const String:sError[], any:iData) {

    if (hResult == INVALID_HANDLE) 
	{	
        PrintToServer("[SQL][ERROR] Save failed! Error: %s", sError);
    } 
	else 
	{
		CloseHandle(hResult);
		hResult = INVALID_HANDLE;
    }
} 
public void OnClientPutInServer(int client)
{
	new String:newSid[64];
	GetClientAuthId(client, AuthId_Engine, newSid, sizeof(newSid));
	for (new i = 1; i <= MaxClients; i++) 
	{
		if(client != playerOldId[i])
		{
			if(StrEqual(newSid, playerSid[i]) && StrEqual(newSid, playerSid[playerOldId[i]]))
			{
				new tmp;
				tmp = playerMinutes[client];
				playerMinutes[client] = playerMinutes[playerOldId[i]];
				playerMinutes[playerOldId[i]] = tmp;
			}
		}
	}
	ResetPlayer(client, false);
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
	SDKHook(client, SDKHook_WeaponCanUse, OnWeaponCanUse);
	
	ClientInSeverTimer[client] = (CreateTimer(60.0, TimerAdd, client, TIMER_REPEAT));
}
public OnClientDisconnect(client)
{
	if (IsClientInGame(client))
	{
		SQL_SaveExp(client);
   
		ResetPlayer(client, true);
		
		playerOldId[client] = client;
		GetClientAuthId(client, AuthId_Engine, playerSid[client], 64);
	}
	
	SDKUnhook(client, SDKHook_OnTakeDamage, OnTakeDamage);
	CloseHandle(ClientInSeverTimer[client]);
}

ShowDamage(victim, attacker, damage)
{
	if (attacker == 0)
	{
		return;
	}
	if (IsFakeClient(attacker) || !IsClientInGame(attacker))
	{
		return;
	}
	
	if (victim != 0)
	{
		if (victim == attacker)
		{
			return;
		}
		else if (GetClientTeam(victim) == GetClientTeam(attacker))
		{
			return;
		}
	}
	
	damageShow[attacker] += damage;
	
	if (blockShowDamageTimer[attacker])
	{
		return;
	}
	
	CreateTimer(0.01, OnShowDamage, attacker);
	blockShowDamageTimer[attacker] = true;
}

public Action:OnShowDamage(Handle:timer, any:client)
{
	blockShowDamageTimer[client] = false;
	
	if (damageShow[client] <= 0 || !client)
	{
		return;
	}
	
	if (!IsClientInGame(client))
	{
		return;
	}
	
	PrintHintText(client, "Obrażenia: %d", damageShow[client]);

	damageShow[client] = 0;
}
public Action Command_Class(int client, int args)
{	
	if(playerClass[client] > 0)
	{
		ForcePlayerSuicide(client);
		SQL_SaveExp(client);
		ResetPlayer(client, false);
		DropItem(client);
		RemovePower(client);
	}
		//load basic classes[class, level] info. When classes not exist create account.
	SQL_PreLoadClass(client);
	
	return Plugin_Handled;
}

public Action Command_Reset(int client, int args)
{	
	if(playerClass[client] > 0)
	{
		new points;
		points = playerAgility[client] + playerDexterity[client] + playerIntelligence[client] + playerStrength[client];
		ForcePlayerSuicide(client);				
		ResetPoints(client);
		playerPoints[client] = points;
		playerHP[client] = ClassHP[playerClass[client]];
		playerSpeed[client] = 0.0;
		SetMenuPoints(client);
		revivingTarget[client] = -1;
	}
	return Plugin_Handled;
}

public Action Command_Exp(int client, int args)
{	
	PrintToChat(client," \x05Gracz \t \x03Exp");
	for (int i = 1; i <= playerKillLastRoundCount[client]; i++)
	{
		PrintToChat(client," \x05%s \t \x03%i", playerKillNamesLastRound[client][i], playerKillExpLastRound[client][i]);
	}
	PrintToChat(client,"To jeszcze nic nie robi :(");
	return Plugin_Handled;
}

public Action Command_Character(int client, int args)
{	
	if(playerClass[client] > 0)
	{
		PrintToChat(client," \x05Twoje statystyki:");
		PrintToChat(client," \x05Inteligencja: \x03%d", playerIntelligence[client]);
		PrintToChat(client," \x05Siła: \x03%d \x05co daje Ci \x03%d \x05wiecej HP.", playerStrength[client], playerHP[client] - ClassHP[playerClass[client]]);
		PrintToChat(client," \x05Zręczność: \x03%d \x05co daje Ci \x03%.2f% \x05redukcji fizycznych ataków.", playerDexterity[client], playerDamageReduction[client]);
		PrintToChat(client," \x05Zwinność: \x03%d \x05co daje Ci \x03%.2f% \x05redukcji magicznych ataków oraz \x03%.2f% \x05do szybkości.", playerAgility[client], playerMagicDamageReduction[client], playerSpeed[client]);
	}
	
	return Plugin_Handled;
}

public Action Command_DropItem(int client, int args)
{	
	if(playerItem[client] > 0)
	{
		DropItem(client);
		PrintToChat(client, " Wyrzucono przedmiot!");
	}
	else
	{
		PrintToChat(client, " Nie posiadasz przedmiotu!");
	}
	return Plugin_Handled;
}

public Action Command_ItemInfo(int client, int args)
{	
	if(playerItem[client] > 0)
	{
		ItemInfo(client);
	}
	else
	{
		PrintToChat(client, " Nie posiadasz przedmiotu!");
	}
	return Plugin_Handled;
}

public Action CreateMenuClass(client)
{
	Menu menu = new Menu(MenuClass_Handler);
	menu.SetTitle("Wybierz klase\n \n");
	for(int i = 1; i < sizeof(Class); i++)
	{
		new String:item[64];
		Format(item, sizeof(item), "%s [%i]", Class[i], playerClassLevel[client][i]);
		if(StrContains(Class[i],"(Vip)") > -1 && playerVip[client] == 0)
			menu.AddItem(NULL_STRING, item, ITEMDRAW_DISABLED);
		else
			menu.AddItem(NULL_STRING, item);
	}
	menu.Display(client, 60);
	return Plugin_Handled;
}

public Action:Command_getTime(client, args)
{
    PrintToChat(client, " \x05Grasz na serwerze przez \x03%d\x05 minut co daje Ci \x03%d%%\x05 wiecej expa!", playerMinutes[client], RoundToFloor(playerMinutes[client] / 5.0) * 5);
    return Plugin_Handled;
}

public int MenuClass_Handler(Menu menu, MenuAction action, int client, int a)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			//Load class.
			SQL_LoadClass(client, a + 1);
			SetHud(client);
		}
		case MenuAction_End:
			delete menu;
	}
	return 0;
}

public Action:SetMenuPointsTimer(Handle:timer, any:client)
{
	isMenuPointsDisplayed[client] = true;
	SetMenuPoints(client);
    KillTimer(handleMenuPoints[client]);
	handleMenuPoints[client] = null;
}

public Action:SetPlayerAbilitiesTimer(Handle:timer, any:client)
{
	SetPlayerHp(client, playerHP[client]);
	SetPlayerSpeed(client, 1.0 + playerSpeed[client]);
    KillTimer(handleSetAbilityTimer[client]);
} 

public Action:TimerAdd(Handle:timer, any:client)
{
	if(IsClientConnected(client) && IsClientInGame(client))
	{
		playerMinutes[client]++;
	}
	blockShowDamageTimer[client] = false;
}

public Action:ResetPlayerLastRoundExpTimer(Handle:timer, any:client)
{
	for (new i = 1; i <= MaxClients; i++) 
	{		
		playerExpLastRound[i] = 0;
		playerKillLastRoundCount[i] = 0;
		GiveDecoys(i);
	}
	KillTimer(timer);
}
public Action:SetTimeFor(Handle:timer, any:client)
{
	for (new i = 1; i <= MaxClients; i++) 
	{
		if(!IsClientConnected(i) || !IsClientInGame(i)) 
		{
			playerMinutes[i] = 0;	
		}
	}
}
public SetMenuPoints(client)
{
	Menu menu = new Menu(MenuPoints_Handler);
	decl String:msg[100];
	Format(msg, sizeof(msg), "Wybierz atrybut - dostepne punkty %d \n \n", playerPoints[client]);
	menu.SetTitle(msg);
	Format(msg, sizeof(msg), "Inteligencja [%d]", playerIntelligence[client]);
	menu.AddItem(NULL_STRING, msg);
	Format(msg, sizeof(msg), "Sila [%d]", playerStrength[client]);
	menu.AddItem(NULL_STRING, msg);
	Format(msg, sizeof(msg), "Zrecznosc [%d]", playerDexterity[client]);
	menu.AddItem(NULL_STRING, msg);
	Format(msg, sizeof(msg), "Zwinnosc [%d]", playerAgility[client]);
	menu.AddItem(NULL_STRING, msg);

	Format(msg, sizeof(msg), "Inteligencja + 25");
	menu.AddItem(NULL_STRING, msg);
	Format(msg, sizeof(msg), "Sila + 25");
	menu.AddItem(NULL_STRING, msg);
	Format(msg, sizeof(msg), "Zrecznosc + 25");
	menu.AddItem(NULL_STRING, msg);
	Format(msg, sizeof(msg), "Zwinnosc + 25");
	menu.AddItem(NULL_STRING, msg);
	menu.ExitButton = false;
	menu.ExitBackButton = false;
	menu.Display(client, 60);
}
public int MenuPoints_Handler(Menu menu, MenuAction action, int client, int a)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch(a)
			{
				case 0:
				{
					playerIntelligence[client]++;
					playerPoints[client]--;
				}
				case 1:
				{
					playerStrength[client]++;
					playerPoints[client]--;
				}
				case 2:
				{
					playerDexterity[client]++;
					playerPoints[client]--;
				}
				case 3:
				{
					playerAgility[client]++;
					playerPoints[client]--;
				}
				case 4:
				{
					if(playerPoints[client] >= 25)
					{
						playerIntelligence[client] += 25;
						playerPoints[client] -= 25;
					}
					else
					{
						playerIntelligence[client] += playerPoints[client];
						playerPoints[client] = 0;
					}
				}
				case 5:
				{
					if(playerPoints[client] >= 25)
					{
						playerStrength[client] += 25;
						playerPoints[client] -= 25;
					}
					else
					{
						playerStrength[client] += playerPoints[client];
						playerPoints[client] = 0;
					}
				}
				case 6:
				{
					if(playerPoints[client] >= 25)
					{
						playerDexterity[client] += 25;
						playerPoints[client] -= 25;
					}
					else
					{
						playerDexterity[client] += playerPoints[client];
						playerPoints[client] = 0;
					}
				}
				case 7:
				{
					if(playerPoints[client] >= 25)
					{
						playerAgility[client] += 25;
						playerPoints[client] -= 25;
					}
					else
					{
						playerAgility[client] += playerPoints[client];
						playerPoints[client] = 0;
					}
				}
			}
			CheckStats(client);
			SetSpecifyStats(client);
			SetPlayerSpeed(client, 1.0 + playerSpeed[client]);
		}
		case MenuAction_End:
			delete menu;
	}
	if(playerPoints[client] > 0 && IsPlayerAlive(client) && handleMenuPoints[client] == null)
	{
		handleMenuPoints[client] = CreateTimer(0.01, SetMenuPointsTimer, client);
	}
	isMenuPointsDisplayed[client] = false;
	return 0;
}
public Action:Event_PlayerChangeTeam(Handle:hEvent, const String:strName[], bool:bBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	if(!IsValidClient(client) || IsFakeClient(client) || GetEventInt(hEvent, "team") > 1)
		return;

		SetHud(client);
}

public Action:Event_PlayerSpawn(Handle:hEvent, const String:strName[], bool:bBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	if(!IsValidClient(client) || IsFakeClient(client))
		return;
		
	blockShowDamageTimer[client] = false;
	SetHud(client);
	if(playerClass[client] > 0)
	{
		handleSetAbilityTimer[client] = CreateTimer(0.1, SetPlayerAbilitiesTimer, client);
		if(playerToSetPoints[client] || CheckAvailablePoints(client))
		{
			if(isMenuPointsDisplayed[client])
				KillTimer(handleMenuPoints[client]);
				
			handleMenuPoints[client] = CreateTimer(0.2, SetMenuPointsTimer, client);
			playerToSetPoints[client] = false;
		}
		if(playerClass[client] == 9)
		{
			playerCooldown[client] = 2.0;
		}
		if(playerClass[client] == 10 && healHandle[client] == null)
		{
			healHandle[client] = CreateTimer(5.0, HealTimer, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
		if(playerClass[client] == 12)
		{
			new String:sz_classname[32];
			new entity_index = GetPlayerWeaponSlot(client, _:Slot_Primary);
			if (IsValidEdict(entity_index))
			{
				GetEdictClassname(entity_index, sz_classname, sizeof(sz_classname));
				CacheClipSize(client, sz_classname[7]);
			}
			entity_index = GetPlayerWeaponSlot(client, _:Slot_Secondary);
			if (IsValidEdict(entity_index))
			{
				GetEdictClassname(entity_index, sz_classname, sizeof(sz_classname));
				CacheClipSize(client, sz_classname[7]);
			}
		}
		//CheckStats(client);
	}
}

public Event_ItemPickup(Handle:event, const String:name[], bool:dontBroadcast)
{
	new String:sz_item[32];
	GetEventString(event, "item", sz_item, sizeof(sz_item));
	CacheClipSize(GetClientOfUserId(GetEventInt(event, "userid")), sz_item);
}

public Action:Event_BombPlanted(Handle:hEvent, const String:strName[], bool:bBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	if(!IsValidClient(client) || IsFakeClient(client))
		return;
	if(playerClass[client] > 0)
	{
		int exp = 0;
		exp = CalcExp(0, client, 3, 0.0);
		GiveExp(client,exp);
		
		playerToSetPoints[client] = CheckNewLevel(client);
		
		SetHud(client);
	}
}

public Action:Event_BombDefused(Handle:hEvent, const String:strName[], bool:bBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	if(!IsValidClient(client) || IsFakeClient(client))
		return;
	if(playerClass[client] > 0)
	{
		int exp = 0;
		exp = CalcExp(0, client, 3, 0.0);
		GiveExp(client,exp);
		
		playerToSetPoints[client] = CheckNewLevel(client);
		
		SetHud(client);
	}
}
public Action:OnWeaponCanUse(client, weapon)
{
    if(!playerIsChicken[client])
    {
        return Plugin_Continue;    
    }
	PrintToChat(client,"test");
    return Plugin_Handled;
}  
public Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3])
{

	if (!IsValidClient(attacker) && damage > 0.0 && IsValidClient(playerIgnitedBy[victim]) && (damagetype & DMG_BURN))
	{
		attacker = playerIgnitedBy[victim];
	}
	if (!IsValidClient(attacker) && damage > 0.0 && IsValidClient(playerIgnitedBy[victim]) && (damagetype & DMG_BURN))
	{
		attacker = playerIgnitedBy[victim];
	}
	if (damage <= 0.0 || victim < 1 || victim > MaxClients || attacker < 1 || attacker > MaxClients)
		return Plugin_Continue;
	
	decl String:classWeapon[32];
	if(IsValidEdict(weapon))
		GetEdictClassname(weapon, classWeapon, sizeof(classWeapon)); 

	if(GetClientTeam(victim) != GetClientTeam(attacker) && IsValidClient(attacker))
	{
		if(playerChanceToCrit[attacker] > 0 || playerBonusChanceToCrit[attacker] > 0)
		{			
			if(GetRandomInt(1, RoundToFloor(100.0 / (playerChanceToCrit[attacker] + playerBonusChanceToCrit[attacker]))) == 1)
			{
				PrintToChat(attacker, "Krytyk!");
				damage *= (1.0 + (playerCritDamage[attacker] + playerBonusCritDamage[attacker] + playerBonusAksjiDamage[attacker]) / 100.0);
			}
		}
		if(!(damagetype & DMG_BURN))
		{
			damage *= (1.0 - playerDamageReduction[victim]);
			
			if(playerBonusReduction[victim] > 1)
			{
				damage -= float(playerBonusReduction[victim]);
			}
		}
		// true damage
		if(StrEqual(classWeapon, "weapon_knife") && playerBonusAdditionalDamageKnife[attacker] > 0)
		{
			damage += float(playerBonusAdditionalDamageKnife[attacker]);
		}
		if(isPlayerSlowed[victim] && (playerAdditionalDamageSlow[attacker] > 0 || playerBonusAdditionalDamageSlow[attacker] > 0 || playerBonusYrdenDamage[attacker] > 0))
		{
			damage += playerAdditionalDamageSlow[attacker] + playerBonusAdditionalDamageSlow[attacker] + playerBonusYrdenDamage[attacker];
		}
		
		if(/*playerAdditionalDamage[attacker] > 0 || */playerBonusAdditionalDamage[attacker] > 0)
		{
			damage += /*playerAdditionalDamage[attacker] + */playerBonusAdditionalDamage[attacker];
		}
		if(playerReflectDamage[victim] > 0 && isReflectionDamage[victim])
		{
			playerDamageToReflect[victim] = RoundToFloor(damage);
			ReflectionOfDamage(attacker, victim);
		}
		if(playerBonusVampire[attacker] > 0)
		{
			damage += float(playerBonusVampire[attacker]);
			AddPlayerHp(attacker, playerBonusVampire[attacker]);
		}
		if(playerClass[attacker] == 13)
		{
			if(playerDamageReduction[attacker] > 20)
				damage *= (playerDamageReduction[attacker] - 20) / 100.0;
		}
		
		int exp = 0;
		exp = CalcExp(victim, attacker, 2, damage);
		GiveExp(attacker,exp);
		
		playerToSetPoints[attacker] = CheckNewLevel(attacker);
		
		ItemWear(victim, RoundToCeil(damage / 15.0));
		
		if(playerMagicHP[victim] > 0)
		{
			if(playerMagicHP[victim] <= playerMagicHPMax[victim])
			{
				playerMagicHP[victim] -= RoundToCeil(damage);
				
				if(playerMagicHP[victim] <= 0)
				{
					UseRadiusSkill(victim);
					ScreenShake(victim);
					playerMagicHP[victim] = 0;
				}
				damage = 0.0;
			}
			else
				playerMagicHP[victim] = 0;
				
			SetHud(victim);
		}
		
		SetHud(attacker);
		
		return Plugin_Changed;
	}
	return Plugin_Continue;
}

public void GiveExp(client, amount)
{
	playerExp[client] += amount;
}

//types 1- exp for kill 2- exp for damage 3- exp for bomb
//set damage only for type = 2
public int CalcExp(victim, attacker, type, float damage)
{
	float currentExp;
	float currentBase;
	switch(type)
	{
		case 1:
		{
			currentBase = BASEEXP * MultipleLevelDifference(victim, attacker);
			currentExp = currentBase + currentBase * MultipleCountPlayers();
			currentExp += currentBase * MultiplePlayerTime(attacker);
			currentExp += currentBase * MultipleKillsSeries(attacker);
			currentExp += currentBase * MultipleUniqueClass(attacker);	
			currentExp += currentBase * MultipleAvgLvl(attacker);	
		}
		case 2:
		{
			currentBase = 1.0 * damage / 10.0;
			currentExp = currentBase + currentBase * MultipleCountPlayers();
			currentExp += currentBase * MultiplePlayerTime(attacker);
			currentExp += currentBase * MultipleUniqueClass(attacker);	
			currentExp += currentBase * MultipleAvgLvl(attacker);	
		}
		case 3:
		{
			currentBase = BASEEXP;
			currentExp = currentBase + currentBase * MultipleCountPlayers();
			currentExp += currentBase * MultiplePlayerTime(attacker);
			currentExp += currentBase * MultipleUniqueClass(attacker);	
			currentExp += currentBase * MultipleAvgLvl(attacker);	
		}
	}
	playerExpLastRound[attacker] += RoundToCeil(currentExp);
	return RoundToCeil(currentExp);
}

public float MultipleLevelDifference(victim, attacker)
{
	if(playerLevel[victim] > playerLevel[attacker])
	{
		return 1.0 + ((playerLevel[victim] - playerLevel[attacker]) * 2.0 / 100.0);
	}
	else if (playerLevel[victim] == playerLevel[attacker])
	{
		return 1.0;
	}
	else
	{
		return ((1.0 - (playerLevel[attacker] - playerLevel[victim]) * 0.5 / 100.0) < 0.10 ) ? 0.10 : (1.0 - (playerLevel[attacker] - playerLevel[victim]) * 0.5 / 100.0);
	}
}

public float MultipleCountPlayers()
{
	if(4 >= GetRealClientCount())
	{
		return 0.0;
	}
	else
	{
		return FloatDiv(float(GetRealClientCount()), float(MAXPLAYERS));
	}
}

public float MultiplePlayerTime(client)
{
	return float(RoundToFloor(playerMinutes[client] / 5.0)) * 5.0 / 100.0;
}

public float MultipleKillsSeries(client)
{
	if(playerKillsSeries[client] < 3)
		return 0.0;	
	else
		return playerKillsSeries[client] * 0.1;
}

public float MultipleUniqueClass(client)
{
	new classCount[14];
	classCount = GetPlayersClassesCount();
	if(classCount[playerClass[client]] > 2)
		return 0.0;
	else if(classCount[playerClass[client]] == 2)
		return 0.1;
	else
		return 0.3;
}

public float MultipleAvgLvl(client)
{
	return RoundToFloor(avgLevel - playerLevel[client] / 25.0) * 0.05;
}

public void SetPlayerHp (int client, int hp)
{
	SetEntityHealth(client, hp);
}

public int AddPlayerHp (int client, int hp)
{
	int currentHp = GetPlayerHp(client);
	int addedHp = 0;
	if((currentHp + hp) >= playerHP[client])
	{
		SetPlayerHp(client, playerHP[client]);
		addedHp = currentHp + hp - playerHP[client];
		if(addedHp < 0)
			addedHp = 0;
	}
	else
	{
		SetPlayerHp(client, currentHp + hp);
		addedHp = hp;
	}
		
	return addedHp;
}

public void SetPlayerInvisibility (int client, int percent)
{
	new alpha;
	alpha = RoundToFloor(percent * 255.0 / 100.0);
	SetEntityRenderMode(client, RENDER_TRANSCOLOR); 
	SetEntityRenderColor(client, 255, 255, 255, alpha); 
}

public int GetPlayerHpPercent (int client, int amount)
{
	return GetClientHealth(client) * amount / 100;
}

public int GetPlayerHp (int client)
{
	return GetClientHealth(client);
}
public void SetPlayerGravity (int client, float amount)
{
	SetEntityGravity(client, amount);
}

void GiveDecoys(client)
{
	for(int j = 0; j < playerDecoyMaxCount[client]; j++)
	{
		GivePlayerItem(client, "weapon_decoy");
	}
}
				
public bool CheckNewLevel(client)
{
	bool isNewLevel = false;
	while(playerExp[client] >= LevelXP[playerLevel[client]] && playerLevel[client] < 1000)//MAX LEVEL 1000
	{
		playerLevel[client]++;
		playerPoints[client] += 2;
		
		SQL_SaveExp(client);
		
		isNewLevel = true;
	}
	return isNewLevel;
}

public bool CheckAvailablePoints(client)
{
	new maxPoints = playerLevel[client] * 2;
	new currentPoints = playerIntelligence[client] + playerStrength[client] + playerDexterity[client] + playerAgility[client] - (playerBonusAllStats[client] + playerBonusIntelligence[client] + playerBonusStrength[client] + playerBonusDexterity[client] + playerBonusAgility[client]);
	
	if(maxPoints > currentPoints)
	{
		playerPoints[client] = maxPoints - currentPoints;
		return true;
	}
	else
		return false;
}

public void CheckStats(client)
{
	playerSpeed[client] = FloatDiv(FloatMul(50.0, 1 - Pow(2.6182,(-0.09798 * playerAgility[client] / 3.0))), 100.0) + playerBonusSpeed[client];
	playerMagicDamageReduction[client] = FloatDiv(FloatMul(70.0, 1 - Pow(2.6182,(-0.09798 * playerAgility[client] / 3.0))), 100.0) + playerBonusMagicDamageReduction[client];
	
	if(playerClass[client] == 13)
		playerDamageReduction[client] = FloatDiv(FloatMul(80.0, 1 - Pow(1.9182,(-0.05798 * playerDexterity[client] / 3.0))), 100.0) + playerBonusDamageReduction[client];
	else
		playerDamageReduction[client] = FloatDiv(FloatMul(50.0, 1 - Pow(2.7182,(-0.09798 * playerDexterity[client] / 3.0))), 100.0) + playerBonusDamageReduction[client];
	
	playerHP[client] = ClassHP[playerClass[client]] + playerStrength[client] * 2 + playerBonusHP[client];
}

public Action:Event_PlayerDeath(Handle:hEvent, const String:strName[], bool:bBroadcast)
{
    new victim = GetClientOfUserId(GetEventInt(hEvent, "userid"));
    new attacker = GetClientOfUserId(GetEventInt(hEvent, "attacker"));
	
	new ragdoll = CreateRagdoll(victim, attacker);
	if(playerClass[attacker] !=0 && victim != attacker)
	{
		ExtinguishEntity(victim);
		
		int exp = 0;
		exp = CalcExp(victim, attacker, 1, 0.0);
		GiveExp(attacker,exp);
		
		SQL_SaveExp(attacker);
		playerToSetPoints[attacker] = CheckNewLevel(attacker);
		playerKillLastRoundCount[attacker] ++;
		playerKillExpLastRound[attacker][playerKillLastRoundCount[attacker]] = exp;
		
		RefillAmmo(attacker);
		SetArmor(attacker);
		
		new String:name[64];
		GetClientName(victim, name, sizeof(name));
		playerKillNamesLastRound[attacker][playerKillLastRoundCount[attacker]] = name;
		
		if(playerItem[attacker] == 0)
			GiveItem(attacker);
	}
	
	if(playerKillsSeries[attacker] < 6 && playerKillsSeries[attacker] != 5)
		playerKillsSeries[attacker]++;
	else
		playerKillsSeries[attacker] = 5;	
	
	playerKillsSeries[victim] = 0;
	
	if(RespawnPlayer(victim))
	{
		if (IsValidEntity(ragdoll))
			AcceptEntityInput(ragdoll, "kill", 0, 0);
	}
	
	if(!IsValidClient(victim))
		return;
	
	ClearSyncHud(victim, g_hHudSync);
	SetHud(attacker);
}

public Action:Timer_ServerHud(Handle:hTimer, Handle:hDataPack)
{
	ResetPack(hDataPack);
	
	new iUserId = ReadPackCell(hDataPack);
	new client = GetClientOfUserId(iUserId);
	if(!IsValidClient(client))
		return;

	if(!IsPlayerAlive(client) && GetClientTeam(client) > 1)
		return;	
	
	decl String:message[220]; 
	if(playerClass[client] == 4 || playerBonusQueen[client] > 0)
		Format(message, sizeof(message),"Klasa: %s Tarcza: %d Skill: %s\nLevel: %d EXP: %d/%d", Class[playerClass[client]], playerMagicHP[client], skillHud[client], playerLevel[client], playerExp[client], LevelXP[playerLevel[client]]);
	else if(playerClass[client] == 5)
		Format(message, sizeof(message), "Klasa: %s \nLevel: %d EXP: %d/%d", Class[playerClass[client]], playerLevel[client], playerExp[client], LevelXP[playerLevel[client]]);
	else if(playerClass[client] == 10)
		Format(message, sizeof(message), "Klasa: %s Skill: %s Leczenie: %s\nLevel: %d EXP: %d/%d", Class[playerClass[client]], skillHud[client], hudOption[client], playerLevel[client], playerExp[client], LevelXP[playerLevel[client]]);
	else
		Format(message, sizeof(message), "Klasa: %s Skill: %s\nLevel: %d EXP: %d/%d", Class[playerClass[client]], skillHud[client], playerLevel[client], playerExp[client], LevelXP[playerLevel[client]]);
	ShowSyncHudText(client, g_hHudSync, message);
}
public SetHud(client)
{
	new Handle:hDataPack;
	CreateDataTimer(0.2, Timer_ServerHud, hDataPack, TIMER_FLAG_NO_MAPCHANGE);
	WritePackCell(hDataPack, GetClientUserId(client));
}

public void SetPlayerSpeed (int client, float amount)
{
	SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", amount);
}

public ResetPlayer(client, bool:disconect)
{
	playerExp[client] = 1;
	playerLevel[client] = 1;
	playerToSetPoints[client] = false;
	playerClass[client] = 0;
	playerHP[client] = 100;
	playerSpeed[client] = 0.0;
	playerIsChicken[client] = false;
	revivingTarget[client] = -1;
	playerDamageToReflect[client] = 0;

	isReflectionDamage[client] = false;
	
	if(disconect)
	{
		for( int i = 0; i<sizeof(Class); i++)
		{
			playerClassLevel[client][i] = 0;
		}
	}

	ResetPoints(client);
	
	//playerMinutes[client] = 0;
	playerKillsSeries[client] = 0;
	
	DropItem(client);
}

public ResetPoints(client)
{
	playerStrength[client] = 0;
	playerIntelligence[client] = 0;
	playerDexterity[client] = 0;
	playerAgility[client] = 0;
	playerPoints[client] = 0;
	
	playerMagicHP[client] = 0;
	playerDamageReduction[client] = 0.0;
	playerMagicDamageReduction[client] = 0.0;
	playerChanceToBurnSkill[client] = 0;
	playerChanceToDropWpnSkill[client] = 0;
	playerChanceToCrit[client] = 0;
	playerCritDamage[client] = 0.0;
	playerAdditionalDamageSlow[client] = 0;
	playerInvisibility[client] = 0;
	playerDecoyMaxCount[client] = 0;
	playerIsInvisible[client] = 0;
	playerHeal[client] = 0;
	playerHealOption[client] = 0;
	playerReflectDamage[client] = 0;
}

public void DealMagicDamage(victim, attacker)
{
	new Float:damage;
	damage = CalculateDamage(victim, attacker);
	ItemWear(victim, RoundToCeil(damage / 15.0));
	if(playerMagicHP[victim] > 0)
	{
		playerMagicHP[victim] -= damage;
		if(playerMagicHP[victim] <= 0)
		{
			UseRadiusSkill(victim);
			ScreenShake(victim);
			playerMagicHP[victim] = 0;
		}
	}
	else
	{
		SDKHooks_TakeDamage(victim, 72, attacker, damage, DMG_CRUSH , -1, NULL_VECTOR, NULL_VECTOR);
	}
	AddEffects(victim, attacker);
	
	GiveExp(attacker,CalcExp(victim, attacker, 2, damage));
}
public Action:ExtinguishPlayerTimer(Handle:timer, any:client)
{
	ExtinguishEntity(client);
	playerIgnitedBy[client] = 0;
}
public Action:CooldownTimer(Handle:timer, any:client)
{
	playerCooldown[client] -= 0.1;
	Format(skillHud[client], 20, "%.2f%", playerCooldown[client]);
	if(playerCooldown[client] <= 0.0)
	{
		playerCooldown[client] = 0.0;
		skillHud[client] = "Gotowy";
		return Plugin_Stop;
	}
		
	SetHud(client);
	return Plugin_Continue;
}

public Action:RemoveChicken(Handle:timer, any:client)
{
	SetEntityModel(client, playerModel[client]);
	ClientCommand(client, "firstperson");
	playerIsChicken[client] = false;
	return Plugin_Continue;
}

public Action:RemovePowerTimer(Handle:timer, any:client)
{
	RemovePower(client);
	return Plugin_Continue;
}

void RemovePower(client)
{
		if(playerBonusIgni[client] > 0)
	{
		playerBonusChanceToBurnSkill[client] -= 20;
		playerBonusIgniDamage[client] -= 0.15;
	
	}
	if(playerBonusAard[client] > 0)
	{
		playerBonusChanceToDropWpnSkill[client] -= 20;
		playerBonusAardDamage[client] -= 0.1;
	}
	if(playerBonusYrden[client] > 0)
	{
		playerBonusYrdenDamage[client] -= 5;
		playerBonusSlow[client] -=10;
	}
	if(playerBonusAksji[client] > 0)
	{
		playerBonusChanceToCrit[client] -= 10;
		playerBonusAksjiDamage[client] -= playerIntelligence[client] * 0.1;
	}
	if(playerBonusQueen[client] > 0)
	{
		playerBonusMagicHP[client] -= playerIntelligence[client] * 0.2;
		playerBonusQueenDamage[client] -= 0.05;
	}
	if(playerBonusCurse[client] > 0)
	{
		playerBonusCurseDamage[client] -= 0.25;
	}
	if(playerBonusFireBall[client] > 0)
	{
		playerBonusFireBallDamage[client] -= 0.15;
	}
	if(playerBonusInvisible[client] > 0)
	{
		SetPlayerInvisibility(client, 100);
	}
	
	playerBonusIgni[client] = 0;
	playerBonusAard[client] = 0;
	playerBonusYrden[client] = 0;
	playerBonusQueen[client] = 0;
	playerBonusAksji[client] = 0;
	playerBonusTeleport[client] = 0;
	playerBonusFireBall[client] = 0;
	playerBonusCurse[client] = 0;
	playerBonusInvisible[client] = 0;
	playerBonusReviving[client] = 0;
}

bool:RespawnPlayer(client)
{
	new bool:respawn;
	respawn = false;
	if(playerBonusChanceToRespawn[client] > 0)
	{
		if(GetRandomInt(1, RoundToFloor(100.0 / (playerBonusChanceToRespawn[client]))) == 1)
		{
			CreateTimer(0.5, RespawnPlayerTimer, client)
			respawn = true;
		}
	}
	// if(playerRevived[client])
	// {
		// CS_RespawnPlayer(client);
		// respawn = true;
	// }
	return respawn;
}

public Action:RespawnPlayerTimer(Handle:timer, any:client)
{
	CS_RespawnPlayer(client);
}
public OnGameFrame()
{
	for (new i = 1; i <= MaxClients; i++) 
	{
		if (IsClientInGame(i) && IsPlayerAlive(i)) 
		{
			CheckJump(i);
		
			if(playerBasePropertyLoaded[i])
			{
				CreateMenuClass(i);
				playerBasePropertyLoaded[i] = false;
			}
			
			TeleportPlayer(i);
			CheckMove(i);
			//test(i);
		}
	}
}

stock CheckJump(any:client) 												//check player jump
{
	new fCurFlags = GetEntityFlags(client)
		//fCurButtons	= GetClientButtons(client)
		
	if (fLastFlags[client] & FL_ONGROUND) 
	{
		// if (																// is start jump
			// !(fCurFlags & FL_ONGROUND) && !(fLastButtons[client] & IN_JUMP) &&	
			// fCurButtons & IN_JUMP				
		// ) {
			// SetPlayerSpeed(client, 1.0);									// set default player speed		
			
			// decl Float:vVel[3];												
			// GetEntPropVector(client, Prop_Data, "m_vecVelocity", vVel);		//	get velocity to scale with seted player speed
																			
			// vVel[0] = FloatMul(vVel[0], 1.0 + playerSpeed[client]);				//
			// vVel[1] = FloatMul(vVel[1], 1.0 + playerSpeed[client]);				//

			// TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vVel);			// set velocity in air
		// }
		if(!(fCurFlags & FL_ONGROUND))
		{
			SetPlayerSpeed(client, 1.0);
			decl Float:vVel[3];												
			GetEntPropVector(client, Prop_Data, "m_vecVelocity", vVel);		//	get velocity to scale with seted player speed
																			
			vVel[0] = FloatMul(vVel[0], 1.0 + playerSpeed[client]);				//
			vVel[1] = FloatMul(vVel[1], 1.0 + playerSpeed[client]);				//

			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vVel);
		}
	}
	else if (	fCurFlags & FL_ONGROUND) 									// is landed
	{
		SetPlayerSpeed(client, 1.0 + playerSpeed[client]); 						//set player speed
	}
		
	fLastFlags[client] = fCurFlags;
	// fLastButtons[client]	= fCurButtons;
}

void TeleportPlayer(any:client) 												//check player jump
{
	new currentButton = GetClientButtons(client);
	new Float:distance;
	new String:weapon[32];
	GetClientWeapon(client, weapon, sizeof(weapon));
	distance = CalculateDistance(client) - 45.0;
	if(playerBonusTeleport[client] > 0 )
		distance += 200;
	if((currentButton & IN_ATTACK2) && playerCooldown[client] == 0 && StrContains(weapon, "weapon_knife") > -1 && distance > 1 && (playerBonusTeleport[client] > 0 || playerClass[client] == 6) && !playerIsChicken[client])
	{
		decl Handle:TraceRay;
		decl Float:StartOrigin[3], Float:Angles[3], Float:fwd[3];
		GetClientEyeAngles(client, Angles);
		GetClientEyePosition(client, StartOrigin);

		fwd[2] = StartOrigin[2];
		fwd[1] = (StartOrigin[1] + (distance * Sine(DegToRad(Angles[1]))));
		fwd[0] = (StartOrigin[0] + (distance * Cosine(DegToRad(Angles[1]))));	
		
		StartOrigin[1] = (StartOrigin[1] + (45.0 * Sine(DegToRad(Angles[1]))));
		StartOrigin[0] = (StartOrigin[0] + (45.0 * Cosine(DegToRad(Angles[1]))));
		
		TraceRay = TR_TraceRayEx(StartOrigin, fwd, MASK_SOLID , RayType_EndPoint);
		
		if(TR_DidHit(TraceRay))
		{
			new Float:end[3];
			TR_GetEndPosition(end, TraceRay);
			end[1] = (end[1] - (45.0 * Sine(DegToRad(Angles[1]))));
			end[0] = (end[0] - (45.0 * Cosine(DegToRad(Angles[1]))));
			
			if (GetVectorDistance(StartOrigin, end) - 45.0 <= distance)
			{
				//end[2] += 0.05;
				TeleportEntity(client, end, NULL_VECTOR, NULL_VECTOR);	
			}	
		}
		else
		{
			//fwd[2] += 0.05;
			TeleportEntity(client, fwd, NULL_VECTOR, NULL_VECTOR);
		}
		
		playerCooldown[client] = 5.0;
		CreateTimer(0.1, CooldownTimer, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		
		CloseHandle(TraceRay);
	}
	
}

void CheckMove(client)
{
	if(!(GetClientButtons(client) & IN_FORWARD) &&
	!(GetClientButtons(client) & IN_BACK) &&
	!(GetClientButtons(client) & IN_MOVELEFT) &&
	!(GetClientButtons(client) & IN_MOVERIGHT) &&
	!(GetClientButtons(client) & IN_JUMP))
	{
		playerMove[client] = false;
		SetInvisible(client);
	}
	else
	{
		playerMove[client] = true;
		SetBleed(client);
	}
}

void SetBleed(client)
{
	if(!playerIsBleed[client] && !(GetClientButtons(client) & IN_WALK) && playerBleedBy[client] > 0)
	{
		playerIsBleed[client] = true;
		CreateTimer(5.0, UnBleedTimer, client);
	}
	else if(playerIsBleed[client])
	{
		for (new i = 0; i < 3; i++)
		{
			ChanceParticle(client, "blood_impact_red_01_backspray");
			ChanceParticle(client, "blood_impact_drops1");
			ChanceParticle(client, "blood_impact_red_01_drops");
		}

		ChanceParticle(client, "blood_impact_red_01_goop_c");
		ChanceParticle(client, "blood_impact_goop_medium");
		ChanceParticle(client, "blood_impact_red_01_goop_b");
		ChanceParticle(client, "blood_impact_red_01_goop_a");
		ChanceParticle(client, "blood_impact_medium");
		ChanceParticle(client, "blood_impact_basic");
	}
}

void MakeBleed(victim, attacker)
{
	playerBleedBy[victim] = attacker;
}

public Action:UnBleedTimer(Handle:timer, any:client)
{
	playerIsBleed[client] = false;
	playerBleedBy[client] = -1;
}

void SetInvisible(client)
{
	new String:weapon[32];
	GetClientWeapon(client, weapon, sizeof(weapon));
	if((playerClass[client] == 9 || playerBonusInvisible[client] > 0) && StrContains(weapon, "weapon_knife") > -1)
		{
			if (playerCooldown[client] == 2.0 && playerIsInvisible[client] == 0)
			{
				//playerCooldown[client] = 2.0;
				CreateTimer(0.1, CooldownTimer, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			}
			else if((playerCooldown[client] == 0 ||playerBonusInvisible[client] > 0) && playerIsInvisible[client] == 0)
			{
				SetPlayerInvisibility(client, playerInvisibility[client] + playerBonusInvisible[client]);
				playerIsInvisible[client] = 1;
			}
		}
		else
		{
			playerMove[client] = true;
			if(playerCooldown[client] < 2.0 && playerIsInvisible[client] == 1)
			{
				playerCooldown[client] = 2.0;
				SetPlayerInvisibility(client, 100);
				playerIsInvisible[client] = 0;
			}
		}
}

void AddEffects(victim, attacker)
{
	
	if( playerClass[attacker] == 1 || playerBonusIgni[attacker] > 0)
	{
		if(GetRandomInt(1, RoundToFloor(100.0 / playerChanceToBurnSkill[attacker])) == 1)
		{
			if(playerIgnitedBy[victim] !=0 )
				ExtinguishEntity(victim);
			playerIgnitedBy[victim] = attacker;
			
			IgniteEntity(victim, 3.0);
			CreateTimer(3.0, ExtinguishPlayerTimer, victim);
		}
	}
	if( playerClass[attacker] == 2 || playerBonusAard[attacker] > 0)
	{
		PushPlayerBack(victim, attacker);			
		ScreenShake(victim);
		if(GetRandomInt(1, RoundToFloor(100.0 / playerChanceToDropWpnSkill[attacker])) == 1)
		{
			DropWeapon(victim);
		}
	}
	if( playerClass[attacker] == 3 || playerBonusYrden[attacker] > 0)
	{
		SlowPlayer(victim, attacker);
	}
	if( playerClass[attacker] == 4 || playerBonusQueen[attacker] > 0)
	{
		PushPlayerBack(victim, attacker);			
		ScreenShake(victim);
	}
	if( playerClass[attacker] == 11)
	{
		if(CanMakeChicken(attacker))
		{
			MakeChicken(victim, attacker);
		}
	}
	if( playerClass[attacker] == 13 && !isReflectionDamage[attacker])
	{
		AttractPlayer(victim, attacker);
		isReflectionDamage[attacker] = true;
		SetEntityRenderColor(attacker, 100, 87, 0, 100);
		ScreenFade(attacker, {100,87,0,100}, 5);
		CreateTimer(5.0, ReflectionTimer, attacker);
	}
}
public float CalculateRadius(client)
{
	float radius;
	switch(playerClass[client])
	{
		case 1:
		{
			radius = 300.0 + playerIntelligence[client];
		}
		case 2:
		{
			radius = 400.0 + playerIntelligence[client] * 1.25;
		}
		case 3:
		{
			radius = 400.0 + playerIntelligence[client] * 1.25;
		}
		case 4:
		{
			radius = 200.0 + playerIntelligence[client];
		}
		default:
		{
			radius = 400.0;
		}
		//case 5:
	}
	return radius;
}
public float CalculateDistance(client)
{
	float distance;
	switch(playerClass[client])
	{
		case 6:
		{
			distance = 600.0 + playerIntelligence[client] * 2;
		}
		case 7:
		{
			distance = 600.0 + playerIntelligence[client] * 2;
		}
		case 11:
		{
			distance = 400.0 + playerIntelligence[client];
		}
	}
	return distance;
}

public Float:CalculateDamage(victim, attacker)
{
	new Float:damage;

	if(playerClass[attacker] == 1 || playerBonusIgni[attacker] > 0)
	{
		damage = GetPlayerHpPercent(victim, 15) + playerIntelligence[attacker] * (0.5 + playerBonusIgniDamage[attacker]);
	}
	if(playerClass[attacker] == 2 || playerBonusAard[attacker] > 0)
	{
		damage = GetPlayerHpPercent(victim, 10) + playerIntelligence[attacker] * (0.25 + playerBonusAardDamage[attacker]);
	}
	if(playerClass[attacker] == 3 || playerBonusYrden[attacker] > 0)
	{
		damage = 0.0;
	}
	if(playerClass[attacker] == 4 || playerBonusQueen[attacker] > 0)
	{
		damage = GetPlayerHpPercent(victim, 5) + playerIntelligence[attacker] * (0.15 + playerBonusQueenDamage[attacker]);
	}
	if(playerClass[attacker] == 7 || playerBonusCurse[attacker] > 0)
	{
		damage = GetPlayerHpPercent(victim, 20)  + playerIntelligence[attacker] * (1.0 + playerBonusCurseDamage[attacker]);
	}
	if(playerClass[attacker] == 8 || playerBonusFireBall[attacker] > 0)
	{
		damage = GetPlayerHpPercent(victim, 10)  + playerIntelligence[attacker] * (0.5 + playerBonusFireBallDamage[attacker]);
	}
	
	damage *= (1.0 - playerMagicDamageReduction[victim]);
	//No reductions damage (true damage)
	if(playerReflectDamage[attacker] > 0 && isReflectionDamage[attacker])
	{
		damage = playerDamageToReflect[attacker] * playerReflectDamage[attacker] / 100.0;
	}
	
	return damage;
}

public float CalculateDuration(attacker)
{
	return (3 + (playerIntelligence[attacker] / 50.0)) > 8.0 ? 8.0 : (3 + (playerIntelligence[attacker] / 50.0));
}

void DropWeapon(client)
{
	ClientCommand(client, "drop");
}
bool:CanMakeChicken(client)
{
	return playerBonusIgni[client] == 0 &&
			playerBonusAard[client] == 0 &&
			playerBonusYrden[client] == 0 &&
			playerBonusQueen[client] == 0 &&
			playerBonusAksji[client] == 0 &&
			playerBonusTeleport[client] == 0 &&
			playerBonusFireBall[client] == 0 &&
			playerBonusCurse[client] == 0 &&
			playerBonusInvisible[client] == 0 &&
			playerBonusReviving[client] == 0;
}
void SlowPlayer(victim, attacker)
{
	new Float:currentSpeed;
	new Float:speed;
	new Float:slow;
	currentSpeed = GetEntPropFloat(victim, Prop_Data, "m_flLaggedMovementValue");
	slow = ((currentSpeed * (10.0 + playerIntelligence[attacker] * 0.25)) / 100.0) > 0.6 ? 0.6 : ((currentSpeed * (10.0 + playerIntelligence[attacker] * 0.25)) / 100.0);
	if(playerBonusSlow[attacker] > 0)
	{
		slow += playerBonusSlow[attacker];
	}
	speed = currentSpeed - slow;
	SetPlayerSpeed(victim, speed);
	isPlayerSlowed[victim] = true;
	CreateTimer(CalculateDuration(attacker), SetDefaultSpeedTimer, victim)
}
void PushPlayerBack(victim, attacker)
{
	new Float:origin[3];
	new Float:attackerloc[3];
	new Float:victimloc[3];
	decl Float:vVel[3];	
	GetEntPropVector(victim, Prop_Send, "m_vecOrigin", origin);											
	GetEntPropVector(victim, Prop_Data, "m_vecVelocity", vVel);
	origin[2] += 1.0;
	GetClientAbsOrigin(attacker, attackerloc);
	GetClientAbsOrigin(victim, victimloc);
	
	MakeVectorFromPoints(attackerloc, victimloc, vVel);
	
	NormalizeVector(vVel, vVel);
	if(playerClass[attacker] == 2)
	{
		ScaleVector(vVel, 200.0);		
		vVel[2] = 200.0;
	}
	else if(playerClass[attacker] == 4)
	{
		ScaleVector(vVel, 100.0);																	
		vVel[2] = 100.0;
	}
	TeleportEntity(victim, origin, NULL_VECTOR, vVel);
}
void AttractPlayer(victim, attacker)
{
	new Float:origin[3];
	new Float:attackerloc[3];
	new Float:victimloc[3];
	decl Float:vVel[3];	
	GetEntPropVector(victim, Prop_Send, "m_vecOrigin", origin);											
	GetEntPropVector(victim, Prop_Data, "m_vecVelocity", vVel);
	origin[2] += 1.0;
	GetClientAbsOrigin(attacker, attackerloc);
	GetClientAbsOrigin(victim, victimloc);
	
	MakeVectorFromPoints(attackerloc, victimloc, vVel);
	
	NormalizeVector(vVel, vVel);
	ScaleVector(vVel, -400.0);		
	vVel[2] = 150.0;
	TeleportEntity(victim, origin, NULL_VECTOR, vVel);
}
public Action:SetDefaultSpeedTimer(Handle:timer, any:client)
{
	SetPlayerSpeed(client, 1.0 + playerSpeed[client]);
	isPlayerSlowed[client] = false;
}
public Action:ReflectionTimer(Handle:timer, any:client)
{
	isReflectionDamage[client] = false;
	SetEntityRenderColor(client, 255, 255, 255, 255);
}

void MakeChicken(victim, attacker)
{
	if(!playerIsChicken[victim])
	{
		GetClientModel(victim, playerModel[victim], 64);
		SetEntityModel(victim, "models/chicken/chicken.mdl");
		
		ClientCommand(victim, "drop");
		ClientCommand(victim, "thirdperson");
		CreateTimer(3.0, RemoveChicken, victim );
		playerIsChicken[victim] = true;
		GainPower(victim, attacker);
		CreateTimer(10.0 + playerIntelligence[attacker] / 15.0, RemovePowerTimer, attacker);
		playerCooldown[attacker] = 1.0;
		PrintToChat(attacker,"cool %f: ", playerCooldown[attacker]);
	}
}

void GainPower(victim, attacker)
{
	switch(playerClass[victim])
	{
		case 1:
		{
			playerBonusIgni[attacker] = 1;
			playerBonusChanceToBurnSkill[attacker] += 20;
			playerBonusIgniDamage[attacker] += 0.15;
		}
		case 2:
		{
			playerBonusAard[attacker] = 1;
			playerBonusChanceToDropWpnSkill[attacker] += 20;
			playerBonusAardDamage[attacker] += 0.1;
		}
		case 3:
		{
			playerBonusYrden[attacker] = 1;
			playerBonusSlow[attacker] = 10;
			playerBonusYrdenDamage[attacker] += 5;
			playerBonusChanceToCrit[attacker] += 10;
		}
		case 4:
		{
			playerBonusQueen[attacker] = 1;
			playerBonusMagicHP[attacker] += playerIntelligence[attacker] * 0.2;
			playerBonusQueenDamage[attacker] += 0.05;
		}
		case 5:
		{
			playerBonusAksji[attacker] = 1;
			playerBonusAksjiDamage[attacker] += playerIntelligence[attacker] * 0.1;
		}
		case 6:
		{
			playerBonusTeleport[attacker] = 1;
		}
		case 7:
		{
			playerBonusCurse[attacker] = 1;
			playerBonusCurseDamage[attacker] += 0.25;
		}
		case 8:
		{
			playerBonusFireBall[attacker] = 1;
			playerBonusFireBallDamage[attacker] += 0.15;
		}
		case 9:
		{
			playerBonusInvisible[attacker] = 50 - ((RoundToFloor(playerIntelligence[attacker] / 5.0)) > 50 ? 50 : (RoundToFloor(playerIntelligence[attacker] / 5.0)));
		}
		case 10:
		{
			playerBonusReviving[attacker] = 1;
		}
	}
	PrintToChat(attacker, "Otrzymano moc postaci: %s", Class[playerClass[victim]]);
}
public Action Command_UseSkill(int client, int args)
{	
	if (IsClientInGame(client) && IsPlayerAlive(client) && !playerIsChicken[client])
	{
		if((playerClass[client] == 1 || playerClass[client] == 2 || playerClass[client] == 3 || playerClass[client] == 13 || playerBonusIgni[client] > 0 || playerBonusAard[client] > 0 || playerBonusYrden[client] > 0) && playerCooldown[client] == 0.0)
		{
			if (playerClass[client] == 2)
				ScreenShake(client);
			
			UseRadiusSkill(client);
			
			playerCooldown[client] = 20.0 - playerBonusReduceCooldown[client];	
			CreateTimer(0.1, CooldownTimer, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
		if((playerClass[client] == 4 || playerBonusQueen[client] > 0) && playerCooldown[client] == 0.0)
		{
			GiveMagicShield(client);
			
			playerCooldown[client] = 20.0 - playerBonusReduceCooldown[client];	
			CreateTimer(0.1, CooldownTimer, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
		if((playerClass[client] == 7 || playerClass[client] == 11 || playerBonusCurse[client] > 0) && playerCooldown[client] == 0.0)
		{
			UseOneHitSkill(client);
		
			playerCooldown[client] = 20.0 - playerBonusReduceCooldown[client];	
			CreateTimer(0.1, CooldownTimer, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
		if((playerClass[client] == 8 || playerBonusFireBall[client] > 0) && playerCooldown[client] == 0.0)
		{
			CreateFireBall(client);
		
			playerCooldown[client] = 10.0 - playerBonusReduceCooldown[client];	
			CreateTimer(0.1, CooldownTimer, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
		if(playerClass[client] == 10)
		{
			if(playerHealOption[client] == 1)
			{
				playerHealOption[client] = 2;
				hudOption[client] = "siebie";
			}
			else if(playerHealOption[client] == 2)
			{
				playerHealOption[client] = 1;
				hudOption[client] = "innych";
			}
			
		}
		SetHud(client);
	}
	return Plugin_Handled;
}
		
UseRadiusSkill(client)
{
	new Float:origin[3];
	GetEntPropVector(client, Prop_Send, "m_vecOrigin", origin);
	origin[2] += 10.0;
	new Float:targetOrigin[3];
	new Float:radius;
	radius = CalculateRadius(client);
	//new weapon = GetPlayerWeaponSlot(client, CS_SLOT_KNIFE);
	for (new victim = 1; victim <= MaxClients; victim++)
	{
		if (!IsClientInGame(victim) || !IsPlayerAlive(victim))
		{
			continue;
		}
		
		GetClientAbsOrigin(victim, targetOrigin);
		targetOrigin[2] += 2.0;
		if (GetVectorDistance(origin, targetOrigin) <= radius)
		{
			new Handle:trace = TR_TraceRayFilterEx(origin, targetOrigin, MASK_SOLID, RayType_EndPoint, FilterTarget, victim);
		
			if (((TR_DidHit(trace) /*&&  TR_GetEntityIndex(trace) == i*/) || (GetVectorDistance(origin, targetOrigin) <= radius)) && victim != client && IsEnemy(client,victim))
			{
				DealMagicDamage(victim, client);
				CloseHandle(trace);
			}
				
			else
			{
				CloseHandle(trace);
				
				GetClientEyePosition(victim, targetOrigin);
				targetOrigin[2] -= 2.0;
		
				trace = TR_TraceRayFilterEx(origin, targetOrigin, MASK_SOLID, RayType_EndPoint, FilterTarget, victim);
			
				if (((TR_DidHit(trace) /*&& TR_GetEntityIndex(trace) == i*/) || (GetVectorDistance(origin, targetOrigin) <= radius)) && victim != client && IsEnemy(client,victim))
				{
					DealMagicDamage(victim, client)
				}
				
				CloseHandle(trace);
			}
		}
	}
	new color[4];
	if(playerClass[client] < 5)
		color = skillColor[playerClass[client]];
	else
		color = YRDENCOLOR;
	TE_SetupBeamRingPoint(origin, 10.0, radius, g_beamsprite, g_halosprite, 1, 1, 0.5, 100.0, 1.0, color, 0, 0);
	TE_SendToAll();
}

UseOneHitSkill(client)
{
	new Float:origin[3];
	GetEntPropVector(client, Prop_Send, "m_vecOrigin", origin);
	origin[2] += 10.0;
	new Float:targetOrigin[3];
	new Float:distance;
	new closestVictim;
	new Float:smallestDistance;
	new Float:closestOrigin[3];
	smallestDistance = -1.0;
	distance = CalculateDistance(client);
	//new weapon = GetPlayerWeaponSlot(client, CS_SLOT_KNIFE);
	for (new victim = 1; victim <= MaxClients; victim++)
	{
		if (!IsClientInGame(victim) || !IsPlayerAlive(victim))
		{
			continue;
		}
		GetClientAbsOrigin(victim, targetOrigin);
		targetOrigin[2] += 2.0;
		if (GetVectorDistance(origin, targetOrigin) <= distance)
		{
			new Handle:trace = TR_TraceRayFilterEx(origin, targetOrigin, MASK_SOLID, RayType_EndPoint, FilterTarget, victim);
			new Float:currentDistance;
			currentDistance = GetVectorDistance(origin, targetOrigin);
			if (((TR_DidHit(trace) &&  TR_GetEntityIndex(trace) == victim) && (currentDistance <= distance)) && victim != client && IsEnemy(client,victim))
			{
				if(smallestDistance < 0 || currentDistance < smallestDistance)
				{
					smallestDistance = currentDistance;
					closestVictim = victim;
				}
				CloseHandle(trace);
			}
				
			else
			{
				CloseHandle(trace);
				
				GetClientEyePosition(victim, targetOrigin);
				targetOrigin[2] -= 2.0;
		
				trace = TR_TraceRayFilterEx(origin, targetOrigin, MASK_SOLID, RayType_EndPoint, FilterTarget, victim);
			
				if (((TR_DidHit(trace) && TR_GetEntityIndex(trace) == victim) && (GetVectorDistance(origin, targetOrigin) <= distance)) && victim != client && IsEnemy(client,victim))
				{		
					if(smallestDistance < 0 || currentDistance < smallestDistance)
					{
						smallestDistance = currentDistance;
						closestVictim = victim;
					}
				}
				
				CloseHandle(trace);
			}
		}
	}
	if(closestVictim > 0)
	{
		GetClientEyePosition(closestVictim, closestOrigin);
		GetClientEyePosition(client, origin);
		entLighting[client] = CreateLighting(closestOrigin, origin);
		CreateTimer(0.3, DestroyLighting, client);
		DealMagicDamage(closestVictim, client);
	}
}

public void CreateFireBall(int client)
{
	new Float:origin[3], Float:angle[3];
	GetClientEyePosition(client, origin);
	GetClientEyeAngles(client, angle);
	
	new Float:pos[3];
	GetAngleVectors(angle, pos, NULL_VECTOR, NULL_VECTOR);
	ScaleVector(pos, 50.0);
	AddVectors(pos, origin, pos);
	
	new Float:player_velocity[3], Float:velocity[3];
	GetEntPropVector(client, Prop_Data, "m_vecVelocity", player_velocity);
	GetAngleVectors(angle, velocity, NULL_VECTOR, NULL_VECTOR);
	ScaleVector(velocity, 1000.0);
	AddVectors(velocity, player_velocity, velocity);

	new entindex = CreateEntityByName("decoy_projectile");
	if (entindex != -1)
	{
		DispatchSpawn(entindex);
		SetEntityModel(entindex, MODEL_MINE);	
		new Float:vecAngVelocity[3] = {0.0, 0.0, 0.0};
		SetEntPropVector(entindex, Prop_Data, "m_vecAngVelocity", vecAngVelocity);
		SetEntPropEnt(entindex, Prop_Send, "m_hOwnerEntity", client);
		SetEntProp(entindex, Prop_Send, "m_usSolidFlags", 12);
		SetEntPropFloat(entindex, Prop_Send, "m_flModelScale", 5.0);

		//new color[4] = {30,144,255,200}; 
		
		SetEntityRenderColor(entindex, 89,35,13,200);
		TE_SetupBeamFollow(entindex, g_beamsprite,	0, Float:1.0, Float:1.5, Float:0.5, 0, IGNICOLOR);
		TE_SendToAll();
		
		TeleportEntity(entindex, pos, NULL_VECTOR, velocity);
		SetEntityMoveType(entindex, MOVETYPE_FLY);
		AcceptEntityInput(entindex, "Ignite");
		
		SDKHook(entindex, SDKHook_StartTouch, OnFireBallTouch);
	}  
}
public Action OnFireBallTouch(int entity) 
{
	new client = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
	
	new Float:origin[3];
	GetEntPropVector(entity, Prop_Send, "m_vecOrigin", origin);
	CreateExplosion(origin, client);

	AcceptEntityInput(entity, "Kill");
	SDKUnhook(entity, SDKHook_StartTouch, OnFireBallTouch);
	
	return Plugin_Continue;
}

public CreateExplosion( Float:vec[3], client) 
{
	new ent = CreateEntityByName("env_explosion");	
	DispatchKeyValue(ent, "classname", "env_explosion");
	SetEntPropEnt(ent, Prop_Data, "m_hOwnerEntity", client);
	
	// new Float:damage;
	// if(victim > 0 && victim < MaxClients + 1 && IsClientInGame(victim) && IsPlayerAlive(victim))
	// {
		// damage = CalculateDamage(victim, client);
	// }
	// new radius = 50;
	
	// SetEntProp(ent, Prop_Data, "m_iMagnitude", 100); 
	// SetEntProp(ent, Prop_Data, "m_iRadiusOverride", radius); 
	DealExplodeDamage(vec, client)

	DispatchSpawn(ent);
	ActivateEntity(ent);

	decl String:exp_sample[64];

	Format( exp_sample, 64, "weapons/hegrenade/explode%d.wav", GetRandomInt( 3, 5 ) );

	EmitAmbientSound( exp_sample, vec, _, SNDLEVEL_GUNFIRE  );

	TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
	AcceptEntityInput(ent, "explode");
	AcceptEntityInput(ent, "kill");
}

DealExplodeDamage(Float:origin[3], client)
{
	origin[2] += 10.0;
	new Float:targetOrigin[3];
	//new weapon = GetPlayerWeaponSlot(client, CS_SLOT_KNIFE);
	for (new victim = 1; victim <= MaxClients; victim++)
	{
		if (!IsClientInGame(victim) || !IsPlayerAlive(victim))
		{
			continue;
		}
		
		GetClientAbsOrigin(victim, targetOrigin);
		targetOrigin[2] += 2.0;
		if (GetVectorDistance(origin, targetOrigin) <= 150)
		{
			new Handle:trace = TR_TraceRayFilterEx(origin, targetOrigin, MASK_SOLID, RayType_EndPoint, FilterTarget, victim);
		
			if (((TR_DidHit(trace) &&  TR_GetEntityIndex(trace) == victim) || (GetVectorDistance(origin, targetOrigin) <= 150)) && victim != client && IsEnemy(client,victim))
			{
				DealMagicDamage(victim, client);
				CloseHandle(trace);
			}			
			else
			{
				CloseHandle(trace);
				
				GetClientEyePosition(victim, targetOrigin);
				targetOrigin[2] -= 2.0;
		
				trace = TR_TraceRayFilterEx(origin, targetOrigin, MASK_SOLID, RayType_EndPoint, FilterTarget, victim);
			
				if (((TR_DidHit(trace) && TR_GetEntityIndex(trace) == victim) || (GetVectorDistance(origin, targetOrigin) <= 150)) && victim != client && IsEnemy(client,victim))
				{
					DealMagicDamage(victim, client)
				}			
				CloseHandle(trace);
			}
		}
	}
}
CreateLighting(Float:start[3], Float:end[3])
{
	new ent = CreateEntityByName("env_beam");
	if (ent != -1)
	{
		TeleportEntity(ent, start, NULL_VECTOR, NULL_VECTOR);
		SetEntityModel(ent, MODEL_LIGHTNING);
		SetEntPropVector(ent, Prop_Data, "m_vecEndPos", end);
		DispatchKeyValue(ent, "renderamt", "255");
		DispatchKeyValue(ent, "decalname", "Bigshot"); 
		DispatchKeyValue(ent, "life", "0"); 
		DispatchKeyValue(ent, "TouchType", "0");
		DispatchSpawn(ent);
		SetEntPropFloat(ent, Prop_Data, "m_fWidth", 10.0); 
		SetEntPropFloat(ent, Prop_Data, "m_fEndWidth", 10.0); 
		ActivateEntity(ent);
		AcceptEntityInput(ent, "TurnOn");
	}
	return ent;
}

public Action:DestroyLighting(Handle:timer, any:client)
{
	AcceptEntityInput(entLighting[client], "Kill");
}
void SetSpecifyStats(client)
{
	switch(playerClass[client])
	{
		case 1: //Lambert
		{
			playerChanceToBurnSkill[client] = 20 + ((RoundToFloor(playerIntelligence[client] / 6.6)) > 30 ? 30 : (RoundToFloor(playerIntelligence[client] / 6.6)));
		}
		case 2: //Geralt
		{
			playerChanceToDropWpnSkill[client] = 20 + ((RoundToFloor(playerIntelligence[client] / 6.6)) > 30 ? 30 : (RoundToFloor(playerIntelligence[client] / 6.6)));
		}
		case 3: //Vesemir
		{
			playerAdditionalDamageSlow[client] = 2 + (RoundToFloor(playerIntelligence[client] / 10.0));
		}
		case 5: //Leto
		{
			playerChanceToCrit[client] = 10 + ((RoundToFloor(playerIntelligence[client] / 25.0)) > 10 ? 10 : (RoundToFloor(playerIntelligence[client] / 25.0)));
			playerCritDamage[client] = 20.0 + ((RoundToFloor(playerIntelligence[client] / 2.0)) > 80 ? 80.0 : float((RoundToFloor(playerIntelligence[client] / 2.0))));
		}
		case 9: //Keira
		{
			playerInvisibility[client] = 50 - ((RoundToFloor(playerIntelligence[client] / 5.0)) > 40 ? 40 : (RoundToFloor(playerIntelligence[client] / 5.0)));
			playerDecoyMaxCount[client] = 1 + (RoundToFloor(playerIntelligence[client] / 50.0));
		}
		case 10: //Felippa
		{
			playerHeal[client] = 5 + (RoundToFloor(playerIntelligence[client] / 10.0));
			if(playerHealOption[client] == 0)
				playerHealOption[client] = 1; // 1 - heal yourself; 2 - heal aliance
		}
		case 12: // Ge'els
		{
			playerChanceToRefillAmmo[client] = 25 + (playerIntelligence[client] > 100 ? 100 : playerIntelligence[client]);
		}
		case 13: //Imlerith
		{
			playerReflectDamage[client] = (10 + (playerIntelligence[client] / 10)) > 50 ? 50 : (10 + (playerIntelligence[client] / 10));
		}
	}
}

GiveMagicShield(client)
{
	playerMagicHP[client] = 20 + playerIntelligence[client] + playerBonusMagicHP[client];
	playerMagicHPMax[client] = 20 + playerIntelligence[client] + playerBonusMagicHP[client];
}
//ITEMS
public void GiveItem(client)
{
	new item;
	item = GetRandomInt(1,10);
	itemEndurance[client] = GetRandomInt(200 + playerDexterity[client], 400 + playerDexterity[client]);
	
	switch(item)
	{
		case 1:
		{
			playerItemName[client] = "Wiedźmiński miecz srebrny";
			playerItem[client] = item;
			new bonus;
			bonus = GetRandomInt(1,5);	
			playerBonusAllStats[client] = bonus;
			
			BoostStats(client);
			PrintToChat(client, " Znalazles przedmiot: %s :: Zyskasz +%i do wszystkich statystyk", playerItemName[client], playerBonusAllStats[client]);	
		}
		case 2:
		{
			playerItemName[client] = "Miecz Hoskulda Rogatego";
			playerItem[client] = item;
			playerBonusChanceToCrit[client] = GetRandomInt(5,10);
			playerBonusCritDamage[client] = float(GetRandomInt(20,40));
			
			PrintToChat(client, " Znalazles przedmiot: %s :: Szansa na krytyka +%i%%. Obrażenia od krytyka + %0.f%", playerItemName[client], playerBonusChanceToCrit[client], playerBonusCritDamage[client]);
		}
		case 3:
		{
			playerItemName[client] = "Drewniany miecz";
			playerItem[client] = item;
			playerBonusAdditionalDamage[client] = GetRandomInt(1,2);
			
			PrintToChat(client, " Znalazles przedmiot: %s :: Zwięszka zadawane obrażenia o %i", playerItemName[client], playerBonusAdditionalDamage[client]);
		}
		case 4:
		{
			playerItemName[client] = "Koszula";
			playerItem[client] = item;
			playerBonusReduction[client] = 1;
			
			PrintToChat(client, " Znalazles przedmiot: %s :: Redukuje %i punkt obrazen", playerItemName[client], playerBonusReduction[client]);
		}
		case 5:
		{
			playerItemName[client] = "Buty egzekutora";
			playerItem[client] = item;
			playerBonusSpeed[client] = GetRandomFloat(100.0, 300.0) / 1000.0;
			playerBonusReduction[client] = 1;
			
			PrintToChat(client, " Znalazles przedmiot: %s :: Redukuje %i punkt obrazen oraz dodaje %0.f% punktów prędkości", playerItemName[client], playerBonusReduction[client], playerBonusSpeed[client] * 1000);
		}
		case 6:
		{
			playerItemName[client] = "Wyrzut sumienia";
			playerItem[client] = item;
			playerBonusReduceCooldown[client] = GetRandomFloat(1.0, 5.0);
			
			PrintToChat(client, " Znalazles przedmiot: %s :: Zmniejsza czas ładowania skilla o %0.f% sek", playerItemName[client], playerBonusReduceCooldown[client]);
		}
		case 7:
		{
			playerItemName[client] = "Trofeum z upiora";
			playerItem[client] = item;
			playerBonusChanceToRespawn[client] = 20;
			
			PrintToChat(client, " Znalazles przedmiot: %s :: Masz %i%% szans na odrodzenie sie po śmierci", playerItemName[client], playerBonusChanceToRespawn[client]);
		}
		case 8:
		{
			playerItemName[client] = "Kovirski kordzik";
			playerItem[client] = item;
			playerBonusAdditionalDamageKnife[client] = GetRandomInt(10, 30);
			
			PrintToChat(client, " Znalazles przedmiot: %s :: Dodatkowe obrażenia do ataków z noża + %i", playerItemName[client], playerBonusAdditionalDamageKnife[client]);
		}
		case 9:
		{
			playerItemName[client] = "Trofeum z ekimmy";
			playerItem[client] = item;
			playerBonusVampire[client] = GetRandomInt(1, 3);
			
			PrintToChat(client, " Znalazles przedmiot: %s :: +%i do wampirycznych obrazen", playerItemName[client], playerBonusVampire[client]);
		}
		case 10:
		{
			playerItemName[client] = "Spodnie Yennefer";
			playerItem[client] = item;
			playerBonusGravity[client] = GetRandomInt(10, 30);
			
			PrintToChat(client, " Znalazles przedmiot: %s :: zmniejszona grawitacja o %i%%", playerItemName[client], playerBonusGravity[client]);
		}
	}
	CheckStats(client);
	SetSpecifyStats(client);
	SetPlayerSpeed(client, 1.0 + playerSpeed[client]);
	SetPlayerGravity(client, 1.0 - (playerBonusGravity[client] / 100.0));
}

public DropItem(client)
{
	SubstStats(client);
	playerItem[client] = 0;
	itemEndurance[client] = 0;
	
	playerBonusAllStats[client] = 0;
	playerBonusAgility[client] = 0;
	playerBonusDexterity[client] = 0;
	playerBonusIntelligence[client] = 0;
	playerBonusStrength[client] = 0;
	
	playerBonusChanceToCrit[client] = 0;
	playerBonusCritDamage[client] = 0.0;
	playerBonusAdditionalDamage[client] = 0;
	playerBonusSpeed[client] = 0.0;
	playerBonusReduction[client] = 0;
	playerBonusReduceCooldown[client] = 0.0;
	playerBonusChanceToRespawn[client] = 0;
	playerBonusAdditionalDamageKnife[client] = 0;
	playerBonusVampire[client] = 0;
	playerBonusGravity[client] = 0;
	
	CheckStats(client);
	SetSpecifyStats(client);
	SetPlayerSpeed(client, 1.0 + playerSpeed[client]);
	SetPlayerGravity(client, 1.0);
}

public void BoostStats(client)
{
	playerAgility[client] += playerBonusAllStats[client];
	playerDexterity[client] += playerBonusAllStats[client];
	playerIntelligence[client] += playerBonusAllStats[client];
	playerStrength[client] += playerBonusAllStats[client];
}

public void SubstStats(client)
{
	playerAgility[client] -= playerBonusAllStats[client];
	playerDexterity[client] -= playerBonusAllStats[client];
	playerIntelligence[client] -= playerBonusAllStats[client];
	playerStrength[client] -= playerBonusAllStats[client];
}

public void ItemWear(client, damage)
{
	if(playerItem[client] > 0)
	{
		if(itemEndurance[client] > 0)
		{
			itemEndurance[client] -= damage;
			if(itemEndurance[client] <= 0)
			{
				PrintToChat(client, "Przedmiot zotał zniszczony!");
				DropItem(client);
			}
		}
		else
			itemEndurance[client] = 0;
	}
}

public void ItemInfo(client)
{
	char buffer[512];
	Format(buffer, sizeof(buffer), "          Opis Przedmiotu %s \n \n", playerItemName[client]);
	
	if(playerBonusAllStats[client] > 0)
	{
		Format(buffer, sizeof(buffer), "%s• Do wszystkich statystyk + %i \n", buffer, playerBonusAllStats[client]);
	}
	if(playerBonusChanceToCrit[client] > 0)
	{
		Format(buffer, sizeof(buffer), "%s• Szansa na krytyka + %i%% \n", buffer, playerBonusChanceToCrit[client]);
	}
	if(playerBonusCritDamage[client] > 0)
	{
		Format(buffer, sizeof(buffer), "%s• Dodatkowe obrazenia od krytyka + %0.f%%% \n", buffer, playerBonusCritDamage[client]);
	}
	if(playerBonusAdditionalDamage[client] > 0)
	{
		Format(buffer, sizeof(buffer), "%s• Dodatkowe obrazenia + %i \n", buffer, playerBonusAdditionalDamage[client]);
	}
	if(playerBonusReduction[client] > 0)
	{
		Format(buffer, sizeof(buffer), "%s• Redukcja obrazen + %i \n", buffer, playerBonusReduction[client]);
	}
	if(playerBonusSpeed[client] > 0)
	{
		Format(buffer, sizeof(buffer), "%s• Zwieksza predkosc biegania o %0.f% punktow \n", buffer, playerBonusSpeed[client] * 1000);
	}
	if(playerBonusReduceCooldown[client] > 0)
	{
		Format(buffer, sizeof(buffer), "%s• Zmniejsza czas ładowania skilla o %0.f% sek \n", buffer, playerBonusReduceCooldown[client]);
	}
	if(playerBonusChanceToRespawn[client] > 0)
	{
		Format(buffer, sizeof(buffer), "%s• Masz %i%% szans na odrodzenie sie po śmierci \n", buffer, playerBonusChanceToRespawn[client]);
	}
	if(playerBonusAdditionalDamageKnife[client] > 0)
	{
		Format(buffer, sizeof(buffer), "%s• Dodatkowe obrażenia do ataków z noża + %i \n", buffer, playerBonusAdditionalDamageKnife[client]);
	}
	if(playerBonusVampire[client] > 0)
	{
		Format(buffer, sizeof(buffer), "%s• +%i do wampirycznych obrazen \n", buffer, playerBonusVampire[client]);
	}
	if(playerBonusGravity[client] > 0)
	{
		Format(buffer, sizeof(buffer), "%s• Zmniejsza grawitacje o %i%% \n", buffer, playerBonusGravity[client]);
	}
	
	Format(buffer, sizeof(buffer), "%s \n          Wytrzymałość Przedmiotu %i", buffer, itemEndurance[client]);
	PanelInfo(client, buffer);
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
//END ITEMS

public bool:FilterTarget(entity, contentsMask, any:data)
{
	return (data == entity);
}

public bool IsEnemy(client,i)
{
	return GetClientTeam(client) != GetClientTeam(i);
}

stock bool:IsValidClient(client)
{
	if(client <= 0 || client > MaxClients || !IsClientInGame(client))
		return false;
	return true;
}
stock int GetRealClientCount()
{
    new iClients = 0;

    for (new i = 1; i <= MaxClients; i++) {
        if (IsClientInGame(i) && !IsFakeClient(i)) 
		{
            iClients++;
        }
    }

    return iClients;
}  
stock int[] GetPlayersClassesCount()
{
	new classCount[14]; 
	for (new i = 1; i <= MaxClients; i++) 
	{
		classCount[playerClass[i]]++;
	}
	return classCount;
} 
stock ScreenShake(client, Float:duration=0.5, Float:amplitude=30.0, Float:frequency=255.0 )
{ 	 
	new Handle:message = StartMessageOne("Shake", client, 1);
	PbSetInt(message, "command", 0);
	PbSetFloat(message, "local_amplitude", amplitude);
	PbSetFloat(message, "frequency", frequency);
	PbSetFloat(message, "duration", duration);
	EndMessage();
}  

stock ScreenFade(client, color[4], hold)
{ 	 
    new Handle:message = StartMessageOne("Fade", client, USERMSG_RELIABLE);
    PbSetInt(message, "duration", 300);
    PbSetInt(message, "hold_time", hold * 1000);
    PbSetInt(message, "flags", 0x0009);
    PbSetColor(message, "clr", color);
    EndMessage();
} 

stock RefillAmmo(client)
{
	if(playerClass[client] == 12)
	{
		if(GetRandomInt(1, RoundToFloor(100.0 / (playerChanceToRefillAmmo[client] /*+ playerBonusChanceToCrit[attacker]*/))) == 1)
		{
		PrintToChat(client,"ammo");
			new clip;
			new entity_index = GetEntDataEnt2(client, g_hActiveWeapon);
			if (IsValidEdict(client))
			{
				if (entity_index == GetPlayerWeaponSlot(client, _:Slot_Primary))
					clip = g_PlayerPrimaryAmmo[client];
				else if (entity_index == GetPlayerWeaponSlot(client, _:Slot_Secondary))
					clip = g_PlayerSecondaryAmmo[client];

				if (clip)
					SetEntData(entity_index, g_iClip1, clip, 4, true);
			}
		}
	}
}
stock SetArmor(client)
{
	if(playerClass[client] == 12)
	{
		SetEntProp( client, Prop_Send, "m_ArmorValue", 100, 1 );
	}
}
stock FreezePlayer(client)
{
	new Float:vec[3];
	GetClientAbsOrigin(client, vec);
	EmitAmbientSound(SOUND_FREEZE, vec, client);

	if(!isPlayerFrozen[client])
	{
		SetEntityMoveType(client, MOVETYPE_WALK);
		isPlayerFrozen[client] = true;
	}
	else
	{
		TE_SetupGlowSprite(vec, g_FreezeSprite, 0.95, 1.5, 50);
		TE_SendToAll();
		SetEntityMoveType(client, MOVETYPE_NONE);
		isPlayerFrozen[client] = false;
	}
}
stock CacheClipSize(client_index, const String:sz_item[])
{
	// Convert first 4 characters of item into an integer for fast comparison (big endian byte ordering)
	// sizeof(sz_item) must be >= 4
	new gun = (sz_item[0] << 24) + (sz_item[1] << 16) + (sz_item[2] << 8) + (sz_item[3]);

	if  (gun==0x6D616737)													// mag7
		g_PlayerPrimaryAmmo[client_index]=5;
	else if  (gun==0x786D3130 || gun==0x73617765)							// xm1014,  sawedoff
		g_PlayerPrimaryAmmo[client_index]=7;
	else if  (gun==0x6D330000 || gun==0x6E6F7661)							// m3,  nova
		g_PlayerPrimaryAmmo[client_index]=8;
	else if  (gun==0x73636F75 || gun==0x61777000 || gun==0x73736730)		// scout,  awp,  ssg08
		g_PlayerPrimaryAmmo[client_index]=10;
	else if  (gun==0x67337367 || gun==0x73636172)							// g3sg1,  scar20
		g_PlayerPrimaryAmmo[client_index]=20;
	else if  (gun==0x66616D61 || gun==0x756D7034)							// famas,  ump45
		g_PlayerPrimaryAmmo[client_index]=25;
	// ak47,  aug,  m4a1,  sg550,  mp5navy,  tmp,  mac10,  mp7,  mp9
	else if  (gun==0x616B3437 || gun==0x61756700 || gun==0x6D346131 || gun==0x73673535
		|| gun==0x6D70356E || gun==0x746D7000 || gun==0x6D616331 || gun==0x6D703700 || gun==0x6D703900)
		g_PlayerPrimaryAmmo[client_index]=30;
	else if  (gun==0x67616C69)												// galil
		g_PlayerPrimaryAmmo[client_index]=35;
	else if  (gun==0x70393000)												// p90
		g_PlayerPrimaryAmmo[client_index]=50;
	else if  (gun==0x62697A6F)												// bizon
		g_PlayerPrimaryAmmo[client_index]=64;
	else if  (gun==0x6D323439)												// m249
		g_PlayerPrimaryAmmo[client_index]=100;
	else if  (gun==0x6E656765)												// negev
		g_PlayerPrimaryAmmo[client_index]=150;
	else if  (gun==0x64656167)												// deagle
		g_PlayerSecondaryAmmo[client_index]=7;
	else if  (gun==0x75737000)												// usp
		g_PlayerSecondaryAmmo[client_index]=12;
	else if  (gun==0x70323238 || gun==0x686B7032 || gun==0x70323530)		// p228,  hkp2000,  p250
		g_PlayerSecondaryAmmo[client_index]=13;
	else if  (gun==0x676C6F63 || gun==0x66697665)							// glock,  fiveseven
		g_PlayerSecondaryAmmo[client_index]=20;
	else if  (gun==0x656C6974)												// elite
		g_PlayerSecondaryAmmo[client_index]=30;
	else if  (gun==0x74656339)												// tec9
		g_PlayerSecondaryAmmo[client_index]=32;
}
//////////////

////////////////
public Action:OnPlayerRunCmd( client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon ) {

	if( !IsValidClient(client) ) return Plugin_Continue;

	if (!(buttons & IN_USE) && g_hReviving[client] != null)
	{
		ClearReviveStuff(client);
	}
	if (buttons & IN_USE)
	{
		RevivePlayer(client);
	}
	return Plugin_Continue;
}

Action RevivePlayer(client)
{
	int aim = GetClientAimTarget(client, false);
	if (aim > MaxClients && (playerClass[client] == 10 || playerBonusReviving[client] > 0))
	{
		if (aim != revivingTarget[client]) {
			if (g_hReviving[client] != null) {
				ClearReviveStuff(client);
			}
		}
		char class[128];
		GetEntityClassname(aim, class, sizeof(class));
		if (!StrEqual(class, "prop_ragdoll", false)) {
			if (g_hReviving[client] != null) {
				ClearReviveStuff(client);
			}
			return Plugin_Continue;
		}
		
		float eyePos[3];
		GetClientEyePosition(client, eyePos);
		float bodyLoc[3];
		GetEntPropVector(aim, Prop_Data, "m_vecOrigin", bodyLoc);
		float vec[3];
		MakeVectorFromPoints(eyePos, bodyLoc, vec);
		if (GetVectorLength(vec) > 150) {
			
			if (g_hReviving[client] != null) {
				ClearReviveStuff(client);
			}
			return Plugin_Continue;
		}
		
		int owner = GetEntPropEnt(aim, Prop_Send, "m_hOwnerEntity");
		if (IsValidClient(owner))
		{
			if (GetClientTeam(owner) == GetClientTeam(client) && g_hReviving[client] == null)
			{
				revivingTarget[client] = aim;
				playerCooldown[client] = 2.0;
				g_hReviving[client] = CreateTimer(0.1, Timer_Revive, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				PrintToChat(client, "\x01Wskrzeszasz \x04%N\x01.", owner);
				// SetEntPropFloat(client, Prop_Data, "m_flProgressBarStartTime", GetGameTime());
				// SetEntProp(client, Prop_Data, "m_iProgressBarDuration", 2);
			}
		}
	}
	return Plugin_Continue;
}
CreateRagdoll(victim, attacker)
{
	float velocity[3];
	int deathBody = GetEntPropEnt(victim, Prop_Send, "m_hRagdoll");
	GetEntPropVector(deathBody, Prop_Data, "m_vecAbsVelocity", velocity);
	if (deathBody > 0)
		AcceptEntityInput(deathBody, "kill", 0, 0);
	
	int ent = CreateEntityByName("prop_ragdoll");
	char sModel[PLATFORM_MAX_PATH];
	GetClientModel(victim, sModel, sizeof(sModel));
	DispatchKeyValue(ent, "model", sModel);
	
	SetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity", victim);
	SetEntProp(ent, Prop_Data, "m_nSolidType", 6);
	SetEntProp(ent, Prop_Data, "m_CollisionGroup", 5);
	
	ActivateEntity(ent);
	
	if (DispatchSpawn(ent))
	{
		float origin[3], angles[3];
		new Float:attackerloc[3];
		new Float:victimloc[3];
		new Float:temp;		
		
		GetClientAbsOrigin(victim, origin);
		GetClientAbsAngles(victim, angles);
		temp = velocity[2];

		GetClientAbsOrigin(attacker, attackerloc);
		GetClientAbsOrigin(victim, victimloc);

		MakeVectorFromPoints(attackerloc, victimloc, velocity);
		
		NormalizeVector(velocity, velocity);

		ScaleVector(velocity, 200.0);		
		velocity[2] = temp;

		TeleportEntity(ent, origin, angles, velocity);
	}
	SetEntProp(ent, Prop_Data, "m_CollisionGroup", 2);
	return ent;
}
public void ClearReviveStuff(int client)
{
	if(g_hReviving[client] != null){
		CloseHandle(g_hReviving[client]);
		g_hReviving[client] = null;
	}
	revivingTarget[client] = -1;
	// SetEntPropFloat(client, Prop_Send, "m_flProgressBarStartTime", GetGameTime() - 2.0);
	// SetEntProp(client, Prop_Send, "m_iProgressBarDuration", 0);
}

public Action Timer_Revive(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	playerCooldown[client] -= 0.1;
	Format(skillHud[client], 20, "%.2f%", playerCooldown[client]);
	if(playerCooldown[client] <= 0.0)
	{
		playerCooldown[client] = 0.0;

		if (!IsValidClient(client))
			return Plugin_Stop;
		g_hReviving[client] = null;
		// SetEntPropFloat(client, Prop_Send, "m_flProgressBarStartTime", GetGameTime() - 2.0);
		// SetEntProp(client, Prop_Send, "m_iProgressBarDuration", 0);
		
		int ent = revivingTarget[client];
		revivingTarget[client] = -1;
		if (!IsValidEntity(ent))
		{
			skillHud[client] = "Użyj";
			return Plugin_Stop;
		}
		
		int aim = GetClientAimTarget(client, false);
		if (ent != aim)
		{
			skillHud[client] = "Użyj";
			return Plugin_Stop;
		}
		
		float eyePos[3];
		GetClientEyePosition(client, eyePos);
		float bodyLoc[3];
		GetEntPropVector(ent, Prop_Data, "m_vecOrigin", bodyLoc);
		float vec[3];
		MakeVectorFromPoints(eyePos, bodyLoc, vec);
		if (GetVectorLength(vec) > 100) {
			skillHud[client] = "Użyj";
			return Plugin_Stop;
		}
		
		int target = GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity");
		if (!IsValidClient(target))
		{
			skillHud[client] = "Użyj";
			return Plugin_Stop;
		}
		PrintToChat(client, "\x01Wskrzesiłeś \x04%N\x01.", target);
		
		CS_RespawnPlayer(target);
		TeleportEntity(target, bodyLoc, NULL_VECTOR, NULL_VECTOR);
		SetEntityHealth(target, 25);
		if (IsValidEntity(ent))
			AcceptEntityInput(ent, "kill", 0, 0);
		
		PrintToChat(target, "  \x01Wskrzesza Cię \x04%N.", client);
		GiveExp(client, CalcExp(0, client, 3, 0.0)/2);
		playerToSetPoints[client] = CheckNewLevel(client);
		skillHud[client] = "Użyj";
		return Plugin_Stop;
	}
		
	SetHud(client);
	return Plugin_Continue;
}
public Action HealTimer(Handle timer, any client)
{
	if(IsValidClient(client) && IsPlayerAlive(client))
	{
		PlayerHeal(client);
		return Plugin_Continue;
	}
	else
	{
		healHandle[client] = null;
		return Plugin_Stop;
	}
}
void PlayerHeal(client)
{
	if(playerHeal[client] > 0)
	{
		if(playerHealOption[client] == 1)
		{
			HealAliance(client);
			SetHud(client);
		}
		else if(playerHealOption[client] == 2)
		{
			AddPlayerHp(client, playerHeal[client]);
		}
	}
}

void HealAliance(client)
{
	new Float:origin[3];
	GetEntPropVector(client, Prop_Send, "m_vecOrigin", origin);
	//origin[2] += 10.0;
	new Float:targetOrigin[3];

	//new weapon = GetPlayerWeaponSlot(client, CS_SLOT_KNIFE);
	for (new aliance = 1; aliance <= MaxClients; aliance++)
	{
		if (!IsClientInGame(aliance) || !IsPlayerAlive(aliance))
		{
			continue;
		}
		
		GetClientAbsOrigin(aliance, targetOrigin);
		targetOrigin[2] += 2.0;
		if (GetVectorDistance(origin, targetOrigin) <= 200)
		{
			new Handle:trace = TR_TraceRayFilterEx(origin, targetOrigin, MASK_SOLID, RayType_EndPoint, FilterTarget, aliance);
		
			if (((TR_DidHit(trace)) || (GetVectorDistance(origin, targetOrigin) <= 200)) && aliance != client && !IsEnemy(client,aliance))
			{
				int healed = AddPlayerHp(aliance, playerHeal[client]);
				CloseHandle(trace);
				
				GiveExp(client, CalcExp(0, client, 2, float(healed)));
				playerToSetPoints[client] = CheckNewLevel(client);
			}
		}
	}
	TE_SetupBeamRingPoint(origin, 10.0, 200.0, g_beamsprite, g_halosprite, 1, 1, 0.5, 10.0, 1.0, IGNICOLOR, 0, 0);
	TE_SendToAll();
}
ReflectionOfDamage(victim, attacker)
{
	DealMagicDamage(victim, attacker);
}

ForcePrecache(String:particleName[])
{
	new particle;

	particle = CreateEntityByName("info_particle_system");
	
	if(IsValidEdict(particle))
	{
		DispatchKeyValue(particle, "effect_name", particleName);
		
		DispatchSpawn(particle);
		ActivateEntity(particle);
		AcceptEntityInput(particle, "start");
		
		CreateTimer(1.0, DeleteParticle, particle, TIMER_FLAG_NO_MAPCHANGE);
	}
}
ChanceParticle(client, String:particleName[])
{
	CreateParticle(client, particleName);
}

CreateParticle(client, String:particleName[])
{
	new particle;
	particle = CreateEntityByName("info_particle_system");
	
	if (IsValidEdict(particle) && IsValidEdict(client))
	{	
		new Float:origin[3];
		new String:targetName[64];

		GetEntPropVector(client, Prop_Send, "m_vecOrigin", origin);

		origin[2] += GetRandomFloat(25.0, 75.0);

		TeleportEntity(particle, origin, NULL_VECTOR, NULL_VECTOR);

		Format(targetName, sizeof(targetName), "Client%d", client);
		DispatchKeyValue(client, "targetname", targetName);
		GetEntPropString(client, Prop_Data, "m_iName", targetName, sizeof(targetName));

		DispatchKeyValue(particle, "targetname", "CSGOParticle");
		DispatchKeyValue(particle, "parentname", targetName);
		DispatchKeyValue(particle, "effect_name", particleName);

		DispatchSpawn(particle);
		
		SetVariantString(targetName);
		AcceptEntityInput(particle, "SetParent", particle, particle, 0);

		ActivateEntity(particle);
		AcceptEntityInput(particle, "start");

		CreateTimer(1.0, DeleteParticle, particle);
	}
}

public Action:DeleteParticle(Handle:Timer, any:particle)
{
	if (IsValidEdict(particle))
	{	
		new String:className[64];

		GetEdictClassname(particle, className, sizeof(className));

		if(StrEqual(className, "info_particle_system", false))
			RemoveEdict(particle);
	}
}
// check
// https://github.com/MitchDizzle/CSGO_AdminESP/blob/master/scripting/csgo_admin_esp.sp
// https://github.com/Franc1sco/MolotovCockTails/blob/master/molotov.sp