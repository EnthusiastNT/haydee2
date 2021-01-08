# Haydee 2
LiveSplitt auto-splitter for Haydee 2 with auto-start, reset on start (optional), and load removal

- [LiveSplit](https://github.com/LiveSplit) - Find out more about LiveSplit. It's a popular timer program typically used for speedruns.
- [ASL](https://github.com/LiveSplit/LiveSplit.AutoSplitters) - More information about .asl scripts and autosplitters in general.

## Features (all optional)

- automatically start the timer when selecting New - Start
- automatically split on any% End
- automatically split on item pick up (select which in Settings)
- automatically reset the timer on Start
- should work when loading from a save (you need to skip splits accordingly)

## Installation 

- start LiveSplit
- right-click > Edit Splits...
- for Game Name enter 'Haydee 2' (exactly like that for LiveSplit to find it)
- click Activate

## Set-up Splits and Icons

Ready-to-use file with all splits that are also enabled by default in Settings.
Includes subsplits and icons from the game.

- download [All Splits with Icons](Haydee_2_Splits_Icons.lss) (click Raw > right-click > Save File...)
- in LiveSplit right-click > Open Layout > From File...
- move splits up and down according to your route

## (manual set-up)

- right-click > Edit Splits...
- Settings
- select items to split on
- enable Start/Split feature at the top

## (edit the script itself)

You may want to change default settings and/or enhance the auto-splitter:

- [Download .asl script](haydee2.asl) (click Raw > right-click > Save File...)
- right-click > Edit Layout...
- add (+) > Control > Scriptable Auto Splitter
- set Script Path to your .asl file
  (LiveSplit automatically catches when you change the .asl)
  
## FAQ

Q: It doesn't split on some items!?  
A: Make sure you have all items in your Layout checked that you have in your Splits list.

Q: It doesn't split on what I collected!?  
A: The auto-splitter is not aware of your Splits list. Make sure to arrange your Splits list in the same order you collect items.

Q: It doesn't split at the end!?  
A: You may have more items checked than splits in your list. Make sure you have exactly as many items checked in your Layout as you have in your Splits.

Q: When I load from a save can I start the timer at 0:00?  
A: We are working on an option for that...

Q: Can I split on a particular room, or when the lights come back on?  
A: No, unfortunately we haven't found a way to split on these, yet.

Q: What are those -dashes in your splits file?  
A: Indents. They indicate subsplits. Add subsplits in Edit Layout > (+) > List > Subsplits

Q: The time is not the same as in the game...!?  
A: Make sure to switch to Game Time (right-click > Control > Game Time)

## Thanks

- Thanks to [Cotaho](https://github.com/Coltaho/), his Timespinner .asl was most helpful!
- Thanks to everyone sharing code snippets and insight on the Speedrun Tool Development [Discord](https://discord.gg/MtVmSggpVb), I've used the search function a lot!

## Contact

If you encounter any issues or have feature requests please let me know! 

- [Enthusiast](https://steamcommunity.com/sharedfiles/filedetails/?id=2315048067) or Enthusiast#2098 on Discord
