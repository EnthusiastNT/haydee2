// auto-splitter for Haydee 2 (available on Steam)
//   (shoutout to Coltaho, his Timespinner.asl was very helpful!)

// patch 1.10(b), depot 26 February 2021 – 12:31:39 (basically 1.09+3080)
state("SteamGame", "1.10")
{
	// switches from 0 to 1 when the game is started (i.e. after 'Press Any Key...')
	//   (however, doesn't work when loading from a save point -> need to start manually)
	bool ppStarted : "SteamGame.exe", 0x8202B0;  // 81D238+3078=8202B0

	// 0x01 when loading
	bool ppLoading : "SteamGame.exe", 0x82A008;  // 826F7C+308C=82A008

	// in-game time as float (4 bytes)
	float ppIngameTime : "SteamGame.exe", 0x82A09C;  // 82701C+3080=82A09C

	// this seems to point to the current room, 0 before start, 0 after end, 0 when loading
	long ppRoomAddr : "SteamGame.exe", 0x82A0B8;  // 827038+3080=82A0B8

	// room name, unicode 64 bytes = 32 chars
	string64 ppRoomName : "SteamGame.exe", 0x82BCF0;  // 828C70+3080=82BCF0

	// number of saves
	int ppNumSaves : "SteamGame.exe", 0x829FE4;  // 826F5C+3088=829FE4
}


// patch 1.09, depot 10, 3 February 2021 – 17:56:44 (basically 1.08+3050)
state("SteamGame", "1.09")
{
	// switches from 0 to 1 when the game is started (i.e. after 'Press Any Key...')
	//   (however, doesn't work when loading from a save point -> need to start manually)
	bool ppStarted : "SteamGame.exe", 0x81D238;  // +0x3000

	// 0x01 when loading
	bool ppLoading : "SteamGame.exe", 0x826F7C;  // +0x3050

	// in-game time as float (4 bytes)
	float ppIngameTime : "SteamGame.exe", 0x82701C;

	// this seems to point to the current room, 0 before start, 0 after end
	long ppRoomAddr : "SteamGame.exe", 0x827038;

	// room name
	string64 ppRoomName : "SteamGame.exe", 0x828C70;  // unicode 64 bytes = 32 chars

	// number of saves
	int ppNumSaves : "SteamGame.exe", 0x826F5C;
}

// patch 1.08(b), depot 19 January 2021 – 16:47:58 (basically 1.07+0x2000)
state("SteamGame", "1.08")
{
	// switches from 0 to 1 when the game is started (i.e. after 'Press Any Key...')
	//   (however, doesn't work when loading from a save point -> need to start manually)
	bool ppStarted : "SteamGame.exe", 0x81A238;

	// 0x01 when loading
	bool ppLoading : "SteamGame.exe", 0x823F2C;

	// in-game time as float (4 bytes)
	float ppIngameTime : "SteamGame.exe", 0x823FCC;

	// this seems to point to the current room, 0 before start, 0 after end
	long ppRoomAddr : "SteamGame.exe", 0x823FE8;

	// room name
	string64 ppRoomName : "SteamGame.exe", 0x825C20;  // unicode 64 bytes = 32 chars

	// number of saves
	int ppNumSaves : "SteamGame.exe", 0x823F0C;
}

// patch 1.07, depot 5 January 2021 – 09:15:23
state("SteamGame", "1.07")
{
	// switches from 0 to 1 when the game is started (i.e. after 'Press Any Key...')
	//   (however, doesn't work when loading from a save point -> need to start manually)
	bool ppStarted : "SteamGame.exe", 0x818238;

	// 0x01 when loading
	bool ppLoading : "SteamGame.exe", 0x821F2C;

	// in-game time as float (4 bytes)
	float ppIngameTime : "SteamGame.exe", 0x821FCC;

	// this seems to point to the current room, 0 before start, 0 after end
	long ppRoomAddr : "SteamGame.exe", 0x821FE8;

	// room name
	string64 ppRoomName : "SteamGame.exe", 0x823C20;  // unicode 64 bytes = 32 chars

	// number of saves
	int ppNumSaves : "SteamGame.exe", 0x821F0C;
}

//state("SteamGame", "2020-12-23") // no changes

/* not good (keeping this for future generations...)
state("SteamGame", "2020-12-18b")
{
	// this becomes 1 when the game is started (i.e. after 'Press Any Key...') (before: 0)
	byte ppStarted : "SteamGame.exe", 0x818238;

	// this seems to be 00000000 when loading (otherwise different in each room)
	long ppLoadingOld : "SteamGame.exe", 0x822040;

	// we would need a list of (important) rooms
	//string32 ppRoomName : "SteamGame.exe", 0x823C2E;  // unicode, (cut off ".scene")
	//string16 ppRoomNameF1 : "SteamGame.exe", 0x83B630;  // only if F1 debug screen is active

	// this seems to point to the current room even without F1 debug
	//long ppRoomAddr : "SteamGame.exe", 0x821FE8;

	// points to the 16 inventory slots, 0x00 to 0x78
	//  - each slot points to an item (or 00000000/garbage)
	//  - each item has an identifying string class, e.g. "CardOrange"
	//  - we split when an item is picked up for the first time
	//long ppSlotBase : "SteamGame.exe", 0x822290, 0x358, 0x10, 0x00, 0x18;
	//string16 ppItem : ppSlotBase, 0x8, 0x10, 0x2C;

	/* replaced with DeepPointer in init bc faster
	string16 ppSlot01 : "SteamGame.exe", 0x822290, 0x358, 0x10, 0x00, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot02 : "SteamGame.exe", 0x822290, 0x358, 0x10, 0x08, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot03 : "SteamGame.exe", 0x822290, 0x358, 0x10, 0x10, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot04 : "SteamGame.exe", 0x822290, 0x358, 0x10, 0x18, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot05 : "SteamGame.exe", 0x822290, 0x358, 0x10, 0x20, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot06 : "SteamGame.exe", 0x822290, 0x358, 0x10, 0x28, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot07 : "SteamGame.exe", 0x822290, 0x358, 0x10, 0x30, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot08 : "SteamGame.exe", 0x822290, 0x358, 0x10, 0x38, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot09 : "SteamGame.exe", 0x822290, 0x358, 0x10, 0x40, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot10 : "SteamGame.exe", 0x822290, 0x358, 0x10, 0x48, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot11 : "SteamGame.exe", 0x822290, 0x358, 0x10, 0x50, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot12 : "SteamGame.exe", 0x822290, 0x358, 0x10, 0x58, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot13 : "SteamGame.exe", 0x822290, 0x358, 0x10, 0x60, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot14 : "SteamGame.exe", 0x822290, 0x358, 0x10, 0x68, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot15 : "SteamGame.exe", 0x822290, 0x358, 0x10, 0x70, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot16 : "SteamGame.exe", 0x822290, 0x358, 0x10, 0x78, 0x18, 0x8, 0x10, 0x2C;
	* /
}
*/

startup {
	print("HDHDHD --- startup enter ---");
	refreshRate = 2;
	vars.needsRescan = true;  // timer runs in a different context, it seems
	vars.whoDidIt = "first";
	vars.cTextRoom = null;  // info text component in Layout
	vars.curRoomName = "";  // full scene name
	vars.bShuttleEntered = false;

	// (int) not used yet, however, could indicate a count in a future version of this script
	vars.itemsAll = new Dictionary<string, int>();
	vars.itemsToFind = new Dictionary<string, int>();  // set in getAllSplits()
	vars.myAddItem = (Func<string, bool, string, string, bool>)((sId, bDefault, sDescription, sTooltip) => {
		if ( !String.IsNullOrEmpty(sDescription) )
			settings.Add(sId, bDefault, sDescription);
		else
			settings.Add(sId, bDefault, sId);
		if ( !String.IsNullOrEmpty(sTooltip) )
			settings.SetToolTip(sId, sTooltip);
		vars.itemsAll[sId] = 1;
		return true;
	});

	// item string class is used as our LiveSplit id
	//   (full list of possible items in Haydee's Edith > Graphite > mHas > Item Class)
	settings.Add("AutoStart", true, "Start timer on 'Press Any Key...'");
	settings.SetToolTip("AutoStart", "note: only auto-starts after a reset");
	settings.Add("LiftOff", true, "Stop timer after Lift Off");
	settings.SetToolTip("LiftOff", "note: only auto-stops if this is your last split");
	settings.Add("AutoReset", true, "Reset timer automatically on new game, or loading a previous save");
	settings.SetToolTip("AutoReset", "warning: not recommended bc things can, and often will, go wrong");

	settings.CurrentDefaultParent = null;
	settings.Add("Options", true, "Options");
	settings.CurrentDefaultParent = "Options";
		settings.Add("ShowRoomName", false, "Add room name to first text of layout");
		settings.SetToolTip("ShowRoomName", "you may need to restart LiveSplit when you change this setting");
		settings.Add("Skip01", false, "auto-skip +1 split (if you disable splits below)");
		settings.Add("Skip02", false, "auto-skip +2 splits");
		settings.Add("Skip04", false, "auto-skip +4 splits");
		settings.Add("Skip08", false, "auto-skip +8 splits");
		settings.Add("Skip16", false, "auto-skip +16 splits");

	settings.CurrentDefaultParent = null;
	settings.Add("pa_Start", true, "Admin (6)");
	settings.CurrentDefaultParent = "pa_Start";
		vars.myAddItem("Squirt", true, "Pistol", "Squirt");
		vars.myAddItem("Screw", true, "Screwdriver", "");
		vars.myAddItem("UpgradeDamage", true, "Damage Upgrade", "red");
		vars.myAddItem("Wrench", true, "Wrench", "");
		vars.myAddItem("N7_ENG_Arena", true, "above Arena", "N7_ENG_Arena");
		vars.myAddItem("CardOrange", true, "Orange", "");

	// blue-before-teal
	settings.CurrentDefaultParent = null;
	settings.Add("pa_Orange", true, "Engineering (5)");
	settings.CurrentDefaultParent = "pa_Orange";
		vars.myAddItem("Clicker", true, "Wifi Clicker", "remote control");
		vars.myAddItem("Boltcutter", true, "Boltcutter", "");
		vars.myAddItem("JackGrip", true, "Lever", "Jack, long lever grip for forklift");
		vars.myAddItem("Crowbar", true, "Crowbar", "");
		vars.myAddItem("Forceps", true, "Forceps", "look like siccors, pincer to reach something");

	settings.CurrentDefaultParent = null;
	settings.Add("pa_Blue", true, "Security (5)");
	settings.CurrentDefaultParent = "pa_Blue";
		vars.myAddItem("N7_SEC_HallTau", true, "Blue enter (hallway with save room)", "N7_SEC_HallTau");
		vars.myAddItem("CardBlue", true, "Blue", "");
		vars.myAddItem("CardWhite", true, "White", "");
		vars.myAddItem("Jammer", true, "Laser Jammer", "red button that disables lasers");
		vars.myAddItem("Visor", true, "Night Vision", "Night Vision Goggles, NVG");

	settings.CurrentDefaultParent = null;
	settings.Add("pa_Teal", true, "Medical (5)");
	settings.CurrentDefaultParent = "pa_Teal";
		vars.myAddItem("Knife", true, "Knife", "");
		vars.myAddItem("CardTeal", true, "Teal", "");
		vars.myAddItem("FlaskB", true, "blue vial", "");
		vars.myAddItem("FlaskA", true, "green vial", "");
		vars.myAddItem("Remote", true, "Wifi Button", "blue receiver button");

	settings.CurrentDefaultParent = null;
	settings.Add("pa_Yellow", true, "Ventilation (6)");
	settings.CurrentDefaultParent = "pa_Yellow";
		vars.myAddItem("Hammer", true, "Hammer", "");
		vars.myAddItem("Mask", true, "Gas Mask", "Breather");
		vars.myAddItem("FlaskC", true, "red vial", "");
		vars.myAddItem("FlaskAgent", true, "White Antidote", "Agent, white vial/flask/tube");
		vars.myAddItem("N7_TEC_Ventilation", true, "Ventilation", "N7_TEC_Ventilation");
		vars.myAddItem("CardYellow", true, "Yellow", "");

	settings.CurrentDefaultParent = null;
	settings.Add("pa_Power", true, "Technical (4)");
	settings.CurrentDefaultParent = "pa_Power";
		vars.myAddItem("Valve", true, "Valve", "(looks like a wheel)");
		vars.myAddItem("Fuse", true, "Fuse", "");
		vars.myAddItem("N7_TEC_ReactorDown", true, "Core", "N7_TEC_ReactorDown");
		vars.myAddItem("N7_TEC_Elevators", true, "Elevator Switch", "N7_TEC_Elevators");

	settings.CurrentDefaultParent = null;
	settings.Add("pa_Finale", true, "Finale");
	settings.CurrentDefaultParent = "pa_Finale";
		vars.myAddItem("Cutter", true, "Blowtorch", "aka Cutter");
		vars.myAddItem("Bracer", true, "Bracelet", "looks like a sports watch");
		vars.myAddItem("Balloon", true, "balloon", "bottle, cylinder");
		vars.myAddItem("Decoder", true, "Decoder", "black device");
		vars.myAddItem("CardBlack", true, "Black", "");
		// and then the lift-off split


	settings.CurrentDefaultParent = null;
	settings.Add("everythingelse", true, "everything else");
	settings.CurrentDefaultParent = "everythingelse";
		vars.myAddItem("Plier", false, "Pliers", "");
		vars.myAddItem("Lockpick", false, "Lockpick", "");
		vars.myAddItem("Flash", false, "Flashdrive", "USB Stick");
		vars.myAddItem("Button", false, "white repair button", "only splits on first one");  // todo_later: split if iCount is 2
		vars.myAddItem("Saw", false, "Saw", "");
		vars.myAddItem("CreeperHandL", false, "Hand Left", "");
		vars.myAddItem("CreeperHandR", false, "Hand Right", "");
		vars.myAddItem("Plug", false, "Power Button", "green power button, splits on first button you take");  // todo_later: split if iCount is 2

		vars.myAddItem("CardGreen", false, "Green", "green keycard");
		vars.myAddItem("CardPink", false, "Pink", "pink keycard");

		vars.myAddItem("Spitter", false, "SMG", "Spitter, also known as Automatic");
		vars.myAddItem("Impaler", false, "Rifle", "Impaler, some call this Magnum");
		vars.myAddItem("Flak", false, "Shotgun", "Flak");
		vars.myAddItem("UpgradeAim", false, "Aim Upgrade", "green");
		vars.myAddItem("UpgradeClip", false, "Clip Upgrade", "yellow");
		vars.myAddItem("UpgradeRate", false, "Rate Upgrade", "blue");

		vars.myAddItem("N7_ENG_HallMid", false, "Orange enter (hallway with save room)", "N7_ENG_HallMid");
		vars.myAddItem("N7_ENG_Packing", false, "Orange Pouch", "N7_ENG_Packing");
		vars.myAddItem("N7_SEC_Interrogation", false, "Blue Pouch", "N7_SEC_Interrogation");
		vars.myAddItem("N7_TEC_TwoWays", false, "Blowtorch room", "N7_TEC_TwoWays");
		vars.myAddItem("N7_ADM_Elevator", false, "the elevator itself", "N7_ADM_Elevator");

/*
		settings.CurrentDefaultParent = "everythingelse";
		settings.Add("mods", true, "not in main game but maybe for a mod");
		settings.CurrentDefaultParent = "mods";
			vars.myAddItem("CardRed", false, "Red (mod)", "");
			vars.myAddItem("CardPurple", false, "Purple (mod)", "");
			vars.myAddItem("CardViolet", false, "Violet (mod)", "");
			vars.myAddItem("CardBrown", false, "Brown (mod)", "");
			vars.myAddItem("SquirtSilent", false, "Silencer (mod)", "");
			vars.myAddItem("UpgradeCharge", false, "Charge Upgrade (mod)", "black, ");
			vars.myAddItem("UpgradeShield", false, "Shield Upgrade (mod)", "purple, ");
			vars.myAddItem("FlaskD", false, "yellow vial (mod)", "");
*/

/*
		settings.CurrentDefaultParent = "everythingelse";
		settings.Add("collectibles", true, "splits on first find only");
		settings.CurrentDefaultParent = "collectibles";
			vars.myAddItem("AmmoPistol", false, "pistol ammo", "");  // red
			vars.myAddItem("AmmoAuto", false, "smg ammo", "");  // blue
			vars.myAddItem("AmmoMagnum", false, "rifle ammo", "");  // yellow
			vars.myAddItem("AmmoShotgun", false, "shotgun ammo", "");  // green
			vars.myAddItem("ComponentA", false, "red jar", "");
			vars.myAddItem("ComponentB", false, "yellow jar", "");
			vars.myAddItem("ComponetsC", false, "blue jar", "");
			vars.myAddItem("Mine", false, "mine", "");
			vars.myAddItem("Medkit", false, "health pack", "");
			vars.myAddItem("Floppy", false, "floppy disk", "");
*/

	settings.CurrentDefaultParent = null;
	settings.Add("info", false, "-- Info --");
	settings.CurrentDefaultParent = "info";
		settings.Add("info1", false, "Haydee 2 Autosplitter v1.14b (by Enthusiast)");
		settings.Add("info2", false, "Supports patches 1.07 to 1.10");
		settings.Add("info3", false, "Split file with icons available at:");
		settings.Add("info9", false, "Website: https://github.com/EnthusiastNT/haydee2");
		settings.CurrentDefaultParent = null;


	// -------------------------------------------
	vars.timerModel = new TimerModel { CurrentState = timer };

	vars.timer_OnStart = (EventHandler)((s, e) => {
		print("HDHDHD timer.OnStart!!!");
		vars.whoDidIt = "OnStart";
		vars.needsRescan = true;
	});
	timer.OnStart += vars.timer_OnStart;

	vars.timer_OnReset = (LiveSplit.Model.Input.EventHandlerT<TimerPhase>)((s, e) => {
		print("HDHDHD timer.OnReset!!!");
		vars.whoDidIt = "OnReset";
		vars.needsRescan = true;
	});
	timer.OnReset += vars.timer_OnReset;

	print("HDHDHD startup done");
}


init {
	print("HDHDHD init enter");

	// maybe: "SteamGame" seems a bit generic, don't update{} if wrong (todo_later: sigscan)
	//vars.isHD2 = modules.First().FileName.Contains("Haydee 2");  // .exe path

	// (int moduleSize = modules.First().ModuleMemorySize;)
	// MD5 code by CptBrian.
	string MD5Hash;
	using (var md5 = System.Security.Cryptography.MD5.Create())
		using (var s = File.Open(modules.First().FileName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
			MD5Hash = md5.ComputeHash(s).Select(x => x.ToString("X2")).Aggregate((a, b) => a + b);
	print("MD5Hash: " + MD5Hash);
	switch (MD5Hash) {
		case "5206DC1FA308259B22AA8FDF14D64116":
			version = "1.07";
			vars.SlotBase = 0x822290;
			break;
		case "CB8A31C01496F9088CC47890D2B48BEE":
			version = "1.08";
			vars.SlotBase = 0x824290;
			break;
		case "4F39A8B27F183313F25D5BB31C46308D":
			version = "1.09";
			vars.SlotBase = 0x8272E0;
			break;
		case "0D354D984F79CB150ECA451255A34250":
		default:
			version = "1.10";
			vars.SlotBase = 0x82A360;  // 8272E0+3080=82A360
			break;
	}

	vars.onceUpdate = false;  // debug
	vars.onceSplit = false;  // debug

	// (btw, this is here in init bc settings isn't available in startup)
	vars.getAllSplits = (Action)(() => {
		vars.itemsToFind.Clear();
		foreach ( string item in vars.itemsAll.Keys )
			if ( settings[item] )
				vars.itemsToFind[item] = 1;
	});

	// init DeepPointers only once (doesn't do anything but store the offsets)
	vars.deepSlots = new Dictionary<string, DeepPointer>();  // deep pointer to slot
	for (int i = 1; i <= 16; i++) {
		int iOffset = (i-1) * 0x08;  // 0 to 15 -> 0x00 to 0x78
		string strName = "slot" + i.ToString("D2");
		vars.deepSlots[strName] = new DeepPointer("SteamGame.exe", vars.SlotBase, 0x358, 0x10, iOffset, 0x18);
	}
// TODO_
	// get slot addresses once (faster), points to 00000000 if slot is not used
	vars.addressSlots = new Dictionary<string, IntPtr>();  // address of slot
	vars.valueSlots = new Dictionary<string, IntPtr>();  // pointer to item object
	vars.getAllSlots = (Func<bool>)(() => {
		bool somethingChanged = false;
		for (int i = 1; i <= 16; i++) {
			string strName = "slot" + i.ToString("D2");
			IntPtr addressSlot;
			vars.deepSlots[strName].DerefOffsets(game, out addressSlot);
			if( vars.addressSlots.ContainsKey(strName) && addressSlot != vars.addressSlots[strName] )
				somethingChanged = true;
			vars.addressSlots[strName] = addressSlot;  // possibly 0x00
			vars.valueSlots[strName] = (IntPtr)0x00;  // at start all slots are empty
		}
		return somethingChanged;
	});

	// debug: print all slots and the containing item, if any
	vars.dbgPrintAllSlots = (Action<string>)((text) => {
		for (int i = 1; i <= 16; i++) {
			string strName = "slot" + i.ToString("D2");
			vars.deepSlot = new DeepPointer(vars.addressSlots[strName], 0x8, 0x10, 0x2C);
			string strItem;
			vars.deepSlot.DerefString(game, 16, out strItem);
			print("HDHDHD " + text + " " + vars.addressSlots[strName].ToString("X12") + "  " + strName + "=" + strItem);
		}
	});

	// debug: print what's left to find
	vars.dbgPrintWhatsLeft = (Action<string>)((text) => {
		bool bFirst = true;
		int iCount = vars.itemsToFind.Count;
		string strList = "(" + iCount + ") ";
		foreach ( string item in vars.itemsToFind.Keys ) {
			if ( !bFirst ) strList += ","; else bFirst = false;
			strList += item;

			if ( strList.Length > 100 ) {
				print("HDHDHD " + text + " " + strList);
				strList = "";
				bFirst = true;
			}
		}
		if ( strList.Length > 0 )
			print("HDHDHD " + text + " " + strList);
	});

	vars.roomChanged = (Action)(() => {
		string str = current.ppRoomName;
		str = str.Replace("Scenes\\", "");
		str = str.Replace(".scene", "");
		vars.curRoomName = str;
		if ( null != vars.cTextRoom ) {
			str = str.Replace("N7_", "");
			str = str.Replace("_", " ");
			vars.cTextRoom.Text1 = str;
			vars.cTextRoom.Text2 = "(" + current.ppNumSaves + " saves)";
		}
	});

	// find first text component
	if ( settings["ShowRoomName"] ) {
		if ( null == vars.cTextRoom ) {
			foreach (dynamic component in timer.Layout.Components) {
				if (component.GetType().Name != "TextComponent") continue;
				vars.cTextRoom = component.Settings;
			}
		}

		// otherwise create one
		if ( null == vars.cTextRoom ) {
			var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
			dynamic textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
			timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));
			textComponent.Settings.Text1 = "current room";
			vars.cTextRoom = textComponent.Settings;
		}

		// room name to text component
		vars.roomChanged();
	}


	// game (re-)started: set everyting back to zero
	vars.getAllSlots();
	vars.dbgPrintAllSlots("init");
	vars.getAllSplits();
	vars.dbgPrintWhatsLeft("init");

	refreshRate = 60;  // todo_release set to 60
	print("HDHDHD init done");
}

update {
	// debug
	if ( !vars.onceUpdate ) {
		print("HDHDHD update enter (once)");
		//vars.dbgPrintAllSlots("update");
		//vars.dbgPrintWhatsLeft("update");
		vars.onceUpdate = true;
	}

	// we good?
	//if ( !vars.isHD2 ) return false;

	// slots completely change in every new room, so we re-scan when room changed
	//   (or after loading, should be the same, just catch them all)
	bool bSlotsDone = false;
	if ( (old.ppRoomAddr != current.ppRoomAddr && 0 != current.ppRoomAddr) ||
		   (old.ppLoading != current.ppLoading && !current.ppLoading) ) {
		if( vars.getAllSlots() )
			vars.dbgPrintAllSlots("room");

		// room changed, so display new room name
		vars.roomChanged();
		bSlotsDone = true;
	}

	// re-scan (once) after timer was started
	if ( vars.needsRescan ) {
		if ( !bSlotsDone ) {
			if( vars.getAllSlots() )
				vars.dbgPrintAllSlots(vars.whoDidIt);
		}
		vars.getAllSplits();
		vars.dbgPrintWhatsLeft(vars.whoDidIt);

		// now, you wanna skip some splits?
		int intTotalSkips = 0;
		if ( settings["Skip01"] )
			intTotalSkips += 1;
		if ( settings["Skip02"] )
			intTotalSkips += 2;
		if ( settings["Skip04"] )
			intTotalSkips += 4;
		if ( settings["Skip08"] )
			intTotalSkips += 8;
		if ( settings["Skip16"] )
			intTotalSkips += 16;
		for (int i = 1; i <= intTotalSkips; i++)
			vars.timerModel.SkipSplit();

		vars.whoDidIt = "";
		vars.needsRescan = false;
		vars.bShuttleEntered = false;
	}
}

start {
	// this switches from 0 to 1 when the game is started (i.e. after 'Press Any Key...')
	//   (however, not after a save-load)
	if ( ( settings["AutoStart"] && !old.ppStarted && current.ppStarted) ) {
		print("HDHDHD AutoStart!!!");
		vars.needsRescan = true;
		return true;
	}

	// after a load from save: was NotRunning, is not loading, yet game time is counting up
/*  does not work: needs a reset before, and resetting would restart automatically...
	if ( false && settings["StartOnLoad"] && TimerPhase.NotRunning == vars.timerModel.CurrentState.CurrentPhase &&
				!current.ppLoading && current.ppIngameTime > old.ppIngameTime ) {
		print("HDHDHD started after load from save!!!");
		// re-scan before start
		if( vars.getAllSlots() )
			vars.dbgPrintAllSlots("load");
		vars.getAllSplits();
		vars.dbgPrintWhatsLeft("load");
		return true;
	}
*/
}

split {
	if ( !vars.onceSplit ) {
		print("HDHDHD split enter (once)");
		vars.onceSplit = true;
	}

	// wow-wow-wow, don't split just yet, re-scan first
	if ( vars.needsRescan )
		return false;

	// anything new collected we haven't split on before?
	for (int i = 1; i <= 16; i++) {
		string strName = "slot" + i.ToString("D2");

		// only deep-scan item if address changed, i.e. new item taken
		IntPtr newValue;
		newValue = memory.ReadValue<IntPtr>((IntPtr)vars.addressSlots[strName]);
		if ( newValue != vars.valueSlots[strName] ) {
			vars.valueSlots[strName] = newValue;
			vars.deepSlot = new DeepPointer(vars.addressSlots[strName], 0x8, 0x10, 0x2C);
			string strItem;
			vars.deepSlot.DerefString(game, 16, out strItem);

			// remove from to-find list
			if ( !String.IsNullOrEmpty(strItem) && vars.itemsToFind.ContainsKey(strItem) ) {
				vars.itemsToFind.Remove(strItem);  // remove item from things to find
				print("HDHDHD split on " + strItem);
				vars.dbgPrintWhatsLeft("-split-");
				return true;  // we got a winner: next split
			}
		}
	}

	// split on some special rooms
	if ( !String.IsNullOrEmpty(vars.curRoomName) && vars.itemsToFind.ContainsKey(vars.curRoomName) ) {
		vars.itemsToFind.Remove(vars.curRoomName);
		vars.dbgPrintWhatsLeft("-split-");
		return true;  // yes, split
	}

	// take note that we have been in Shuttle, otherwise don't auto-split on lift-off
	if ( !vars.bShuttleEntered && !String.IsNullOrEmpty(vars.curRoomName) && vars.curRoomName.Contains("N7_SEC_Shuttle") ) {
		print("(yes, Shuttle entered)");
		vars.bShuttleEntered = true;
	}

	// end reached, no more room (ppRoomAddr is also 0 while loading)
	if ( !current.ppLoading && 0 != old.ppRoomAddr && 0 == current.ppRoomAddr ) {
		// timer ist 0 or very small? then this was a New Game and subsequent load from save
		if ( vars.bShuttleEntered && current.ppIngameTime > 100.0 ) {
			print("HDHDHD --- Lift Off ---");
			if ( settings["LiftOff"] )
				return true;
		}
	}
	// todo_later: find lift-off pointer path to be able to stop sooner
}

reset {
	// time smaller than before? then this was a New Game or load from save
	if ( !current.ppLoading && current.ppIngameTime < old.ppIngameTime ) {
		print("HDHDHD reset!!!");
		if ( settings["AutoReset"] )
			return true;
	}
}

gameTime {
	return TimeSpan.FromSeconds(current.ppIngameTime);
}

isLoading {
	return true;  // always use gameTime{}
	//return current.ppLoading;
}

shutdown {
	print("HDHDHD shutdown enter");
	timer.OnStart -= vars.timer_OnStart;
	timer.OnReset -= vars.timer_OnReset;
}
