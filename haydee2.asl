// autosplitter for Haydee 2 (available on Steam)
//  - kudos to Coltaho and his Timespinner.asl, was extremely helpful!

// (version is not used yet, may need to hash bc silent updates...)
state("SteamGame", "1.07")
{
	// switches from 0 to 1 when the game is started (i.e. after 'Press Any Key...')
	//   (however, doesn't work when loading from a save point -> need to start manually)
	bool ppStarted : "SteamGame.exe", 0x00818238;

	// 0x01 when loading
	bool ppLoading : "SteamGame.exe", 0x00821F2C;

	// in-game time as float (4 bytes)
	float ppIngameTime : "SteamGame.exe", 0x00821FCC;

	// this seems to point to the current room, 0 before start, 0 after end
	long ppRoomAddr : "SteamGame.exe", 0x00821FE8;
}

/* not good (keeping this for future generations...)
state("SteamGame", "1.06")
{
	// this becomes 1 when the game is started (i.e. after 'Press Any Key...') (before: 0)
	byte ppStarted : "SteamGame.exe", 0x00818238;

	// this seems to be 00000000 when loading (otherwise different in each room)
	long ppLoadingOld : "SteamGame.exe", 0x00822040;

	// e.g. N7_ENG_Diagnostics, 
	// also, we would need a list of (important) rooms
	//string32 ppRoomName : "SteamGame.exe", 0x00823C2E;  // unicode, (cut off ".scene")
	//string16 ppRoomNameF1 : "SteamGame.exe", 0x0083B630;  // only if F1 debug screen is active

	// this seems to point to the current room even without F1 debug
	//long ppRoomAddr : "SteamGame.exe", 0x00821FE8;

	// points to the 16 inventory slots, 0x00 to 0x78
	//  - each slot points to an item (or 00000000/garbage)
	//  - each item has an identifying string class, e.g. "CardOrange"
	//  - we split when an item is picked up for the first time
	//long ppSlotBase : "SteamGame.exe", 0x00822290, 0x358, 0x10, 0x00, 0x18;
	//string16 ppItem : ppSlotBase, 0x8, 0x10, 0x2C;

	/* replaced with DeepPointer in init bc faster
	string16 ppSlot01 : "SteamGame.exe", 0x00822290, 0x358, 0x10, 0x00, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot02 : "SteamGame.exe", 0x00822290, 0x358, 0x10, 0x08, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot03 : "SteamGame.exe", 0x00822290, 0x358, 0x10, 0x10, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot04 : "SteamGame.exe", 0x00822290, 0x358, 0x10, 0x18, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot05 : "SteamGame.exe", 0x00822290, 0x358, 0x10, 0x20, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot06 : "SteamGame.exe", 0x00822290, 0x358, 0x10, 0x28, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot07 : "SteamGame.exe", 0x00822290, 0x358, 0x10, 0x30, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot08 : "SteamGame.exe", 0x00822290, 0x358, 0x10, 0x38, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot09 : "SteamGame.exe", 0x00822290, 0x358, 0x10, 0x40, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot10 : "SteamGame.exe", 0x00822290, 0x358, 0x10, 0x48, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot11 : "SteamGame.exe", 0x00822290, 0x358, 0x10, 0x50, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot12 : "SteamGame.exe", 0x00822290, 0x358, 0x10, 0x58, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot13 : "SteamGame.exe", 0x00822290, 0x358, 0x10, 0x60, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot14 : "SteamGame.exe", 0x00822290, 0x358, 0x10, 0x68, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot15 : "SteamGame.exe", 0x00822290, 0x358, 0x10, 0x70, 0x18, 0x8, 0x10, 0x2C;
	string16 ppSlot16 : "SteamGame.exe", 0x00822290, 0x358, 0x10, 0x78, 0x18, 0x8, 0x10, 0x2C;
	* /
}
*/

startup {
	print("HDHDHD --- startup enter ---");
	refreshRate = 2;
	vars.needsRescan = true;
	vars.whoDidIt = "";

	// (int) not used, however, could indicate a count in a future version of this script
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
	vars.myAddItem("AutoStart", true, "Start timer on 'Press Any Key...'", "note: timer only starts automatically after a reset");
	vars.myAddItem("LiftOff", true, "Stop timer after Lift Off", "note: only stops automatically if this is your last split");
	vars.myAddItem("AutoReset", true, "Reset timer on new game, and after load from save", "");

	settings.CurrentDefaultParent = null;
	settings.Add("Cards", true);
	settings.CurrentDefaultParent = "Cards";
		vars.myAddItem("CardOrange", true, "Orange", "");
		vars.myAddItem("CardGreen", false, "Green", "");
		vars.myAddItem("CardWhite", true, "White", "");
		vars.myAddItem("CardPink", false, "Pink", "");
		vars.myAddItem("CardTeal", true, "Teal", "");
		vars.myAddItem("CardBlue", true, "Blue", "");
		vars.myAddItem("CardYellow", true, "Yellow", "");
		vars.myAddItem("CardBlack", true, "Black", "");
		vars.myAddItem("CardRed", false, "Red (mod)", "not in main game but maybe for a mod");
		vars.myAddItem("CardPurple", false, "Purple (mod)", "not in main game but maybe for a mod");
		vars.myAddItem("CardViolet", false, "Violet (mod)", "not in main game but maybe for a mod");
		vars.myAddItem("CardBrown", false, "Brown (mod)", "not in main game but maybe for a mod");

	settings.CurrentDefaultParent = null;
	settings.Add("Tools", true);
	settings.CurrentDefaultParent = "Tools";
		vars.myAddItem("Plier", false, "Pliers", "");
		vars.myAddItem("Screw", true, "Screwdriver", "");
		vars.myAddItem("Wrench", true, "", "");
		vars.myAddItem("JackGrip", true, "Lever", "Jack, long lever grip for forklift");
		vars.myAddItem("Boltcutter", true, "", "");
		vars.myAddItem("Clicker", true, "Wifi Remote", "Clicker, remote control");
		vars.myAddItem("Remote", true, "Wifi Button", "blue receiver button");
		vars.myAddItem("Crowbar", true, "", "");
		vars.myAddItem("Forceps", true, "", "look like siccors, pincer to reach something");
		vars.myAddItem("Knife", true, "", "");
		vars.myAddItem("Jammer", true, "Laser Jammer", "red button that disables lasers");
		vars.myAddItem("Hammer", true, "", "");

	settings.CurrentDefaultParent = null;
	settings.Add("Other", true);
	settings.CurrentDefaultParent = "Other";
		vars.myAddItem("Visor", true, "Night Vision", "Night Vision Goggles, NVG");
		vars.myAddItem("Mask", true, "Gas Mask", "Breather");
		vars.myAddItem("FlaskAgent", true, "White Antidote", "Agent, white vial/flask/tube");
		vars.myAddItem("Plug", false, "Power Button", "green power button, splits on first button you take");  // todo_later: split if iCount is 2
		vars.myAddItem("Cutter", true, "Blowtorch", "aka Cutter");
		vars.myAddItem("Flash", false, "Flashdrive", "USB Stick");
		vars.myAddItem("Lockpick", false, "", "");
		vars.myAddItem("Bracer", true, "Bracelet", "looks like a Fitbit");
		vars.myAddItem("Decoder", true, "Decoder", "that black device at the end");
		vars.myAddItem("Balloon", true, "gas cylinder", "balloon, looks like a refillable gas bottle");

	settings.CurrentDefaultParent = null;
	settings.Add("Guns", true);
	settings.CurrentDefaultParent = "Guns";
		vars.myAddItem("Squirt", true, "Pistol", "Squirt");
		vars.myAddItem("Spitter", false, "SMG", "Spitter, also known as Automatic");
		vars.myAddItem("Impaler", false, "Rifle", "Impaler, some call this Magnum");
		vars.myAddItem("Flak", false, "Shotgun", "Flak");
		vars.myAddItem("SquirtSilent", false, "Silencer (mod)", "not in main game but maybe for a mod");
		vars.myAddItem("UpgradeAim", false, "Aim Upgrade", "green");
		vars.myAddItem("UpgradeClip", false, "Clip Upgrade", "yellow");
		vars.myAddItem("UpgradeDamage", true, "Damage Upgrade", "red");
		vars.myAddItem("UpgradeRate", false, "Rate Upgrade", "blue");
		vars.myAddItem("UpgradeCharge", false, "Charge Upgrade (mod)", "black, not in main game but maybe for a mod");
		vars.myAddItem("UpgradeShield", false, "Shield Upgrade (mod)", "purple, not in main game but maybe for a mod");

	settings.CurrentDefaultParent = null;
	settings.Add("single_use", true, "single use items");
	settings.CurrentDefaultParent = "single_use";
		vars.myAddItem("Button", false, "white button", "only splits on first one");  // todo_later: split if iCount is 2
		vars.myAddItem("Saw", false, "", "");
		vars.myAddItem("CreeperHandL", false, "Hand Left", "");
		vars.myAddItem("CreeperHandR", false, "Hand Right", "");
		vars.myAddItem("FlaskA", false, "green vial", "");
		vars.myAddItem("FlaskB", false, "blue vial", "");
		vars.myAddItem("FlaskC", false, "red vial", "");
		vars.myAddItem("FlaskD", false, "yellow vial (mod)", "not in main game but maybe for a mod");
		vars.myAddItem("Valve", true, "", "(looks like a wheel)");
		vars.myAddItem("Fuse", true, "", "");

	// may not make sense to split on, but we use it the verify slots
	settings.CurrentDefaultParent = null;
	settings.Add("collectibles", true);
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
		//vars.myAddItem("Pouch", false, "");  // yeah that doesn't work...


	settings.CurrentDefaultParent = null;
	settings.Add("info", false, "-- Info --");
	settings.CurrentDefaultParent = "info";
	settings.Add("info1", false, "Haydee 2 Autosplitter v1.02 by Enthusiast");
	settings.Add("info2", false, "Supports Haydee 2.0 patch 1.07 (Steam)");
	settings.Add("info9", false, "Website: https://github.com/EnthusiastNT/haydee2");
	settings.CurrentDefaultParent = null;

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

	// "SteamGame" seems a bit generic, don't update{} if wrong (todo_later: sigscan)
	//vars.isHD2 = modules.First().FileName.Contains("Haydee 2");  // .exe path

	/* function declarations */

	vars.onceUpdate = false;  // debug
	vars.onceSplit = false;  // debug

	// (btw, this is here in init{} bc settings isn't available in startup{} )
	vars.getAllSplits = (Action)(() => {
		vars.itemsToFind.Clear();
		foreach ( string item in vars.itemsAll.Keys )
			if ( settings[item] )
				vars.itemsToFind[item] = 1;  // if still checked in settings
	});

	// init DeepPointers only once (doesn't do anything but store the offsets)
	vars.deepSlots = new Dictionary<string, DeepPointer>();  // deep pointer to slot
	for (int i = 1; i <= 16; i++) {
		int iOffset = (i-1) * 0x08;  // 0 to 15 -> 0x00 to 0x78
		string strName = "slot" + i.ToString("D2");
		vars.deepSlots[strName] = new DeepPointer("SteamGame.exe", 0x00822290, 0x358, 0x10, iOffset, 0x18);
	}

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
		string strList = "";
		foreach ( string item in vars.itemsToFind.Keys ) {
			if ( !bFirst ) strList += ","; else bFirst = false;
			strList += item;

			if ( strList.Length > 80 ) {
				print("HDHDHD " + text + " " + strList);
				strList = "";
				bFirst = true;
			}
		}
		print("HDHDHD " + text + " " + strList);
	});


	/* init real start */

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
		vars.dbgPrintWhatsLeft("update");
		vars.onceUpdate = true;
	}

	// we good?
	//if ( !vars.isHD2 ) return false;

	// slots completely change in every new room, so we re-scan when room changed
	//   (or after loading, should be the same, just catch them all)
	bool SlotsDone = false;
	if ( (old.ppRoomAddr != current.ppRoomAddr && 0 != current.ppRoomAddr) ||
			(old.ppLoading != current.ppLoading && !current.ppLoading) ) {
		if( vars.getAllSlots() )
			vars.dbgPrintAllSlots("room");
		SlotsDone = true;
	}

	// re-scan if timer was started manually e.g. after loading from a save point
	if ( vars.needsRescan ) {
		if ( !SlotsDone ) {
			if( vars.getAllSlots() )
				vars.dbgPrintAllSlots(vars.whoDidIt);
		}
		vars.getAllSplits();
		vars.dbgPrintWhatsLeft(vars.whoDidIt);
		vars.whoDidIt = "";
		vars.needsRescan = false;
	}
}

start {
	// this switches from 0 to 1 when the game is started (i.e. after 'Press Any Key...')
	//   (however, not after a save-load)
	if ( vars.itemsToFind.ContainsKey("AutoStart") && !old.ppStarted && current.ppStarted ) {
		print("HDHDHD AutoStart!!!");
		// re-scan before start
		if( vars.getAllSlots() )
			vars.dbgPrintAllSlots("AutoStart");
		vars.getAllSplits();
		vars.dbgPrintWhatsLeft("AutoStart");

		vars.itemsToFind.Remove("AutoStart");
		return true;
	}
}

split {
	if ( !vars.onceSplit ) {
		print("HDHDHD split enter (once)");
		vars.onceSplit = true;
	}


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

	// end reached, no more room (ppRoomAddr is 0 while loading)
	if ( !current.ppLoading && 0 != old.ppRoomAddr && 0 == current.ppRoomAddr ) {
		// timer ist 0? then this was a New Game or load from save
		if ( current.ppIngameTime > 100.0 ) {
			print("HDHDHD --- Lift Off ---");
			if ( vars.itemsToFind.ContainsKey("LiftOff") )
				return true;  // don't remove for now, might be false alarm due to timing issues
		}
	}
	// todo_later: find lift-off pointer path to be able to stop sooner

	// todo_later: text box with room name (so you don't need F1 debug anymore)
	//   also maybe number of saves (to differentiate between practice and run)
}

reset {
	// time smaller than before? oops, then this was a New Game or load from save
	if ( !current.ppLoading && current.ppIngameTime < old.ppIngameTime ) {
		print("HDHDHD reset!!!");
		if ( vars.itemsToFind.ContainsKey("AutoReset") )
			return true;
	}
}

gameTime {
	return TimeSpan.FromSeconds(current.ppIngameTime);
}

isLoading {
	return true;  // use gameTime{}
	//return current.ppLoading;
}

exit {
//	print("HDHDHD exit enter");
}

shutdown {
	print("HDHDHD shutdown enter");
	timer.OnStart -= vars.timer_OnStart;
	timer.OnReset -= vars.timer_OnReset;
}


/*

FAQ

Q: It doesn't split on some items!?
A: Make sure you have all items in your Layout checked that you have in your Splits list.

Q: It doesn't split on what I collected!?
A: The auto-splitter is not aware of your Splits list. Make sure to arrange your Splits list
	in the same order you collect items.

Q: It doesn't split at the end!?
A: You may have more items checked than splits in your list. Make sure
	you have exactly as many items checked in your Layout as you have in your Splits.

Q: When I load from a save can I start the timer at 0:00?
A: We are working on an option for that...

Q: Can I split on a particular room, or when the lights are back on?
A: No, unfortunately we haven't found a way to split on these, yet.

Q: Can I customize the script?
A: Yes, you can change default settings and/or enhance the auto-splitter:
	- download haydee2.asl
	- add Scriptable Auto Splitter (+ > Control > Scriptable Auto Splitter)
	- set Script Path to your .asl file
	- LiveSplit automatically catches when you change the .asl

Q: What are those -dashes in your splits file?
A: They indicate subsplits. Add Subsplits in Edit Layout > [+] > List > Subsplits

Q: The time is not the same as in the game...!?
A: Make sure to switch to Game Time (right-click > Control > Game Time)

------------
    <AutoSplitter>
        <Games>
            <Game>Haydee2</Game>
            <Game>Haydee 2</Game>
            <Game>Haydee 2.0</Game>
        </Games>
        <URLs>
            <URL>https://github.com/EnthusiastNT/haydee2/blob/main/haydee2.asl</URL>
        </URLs>
        <Type>Script</Type>
        <Description>Configurable Load Remover / Auto Splitter. (By DevilSquirrel)</Description>
        <Website>https://github.com/ShootMe/LiveSplit.HollowKnight</Website>
    </AutoSplitter>

*/
