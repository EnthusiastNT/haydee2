# Haydee 2
LiveSplitt auto-splitter for Haydee 2 with auto-start, reset on start (optional), and load removal
<img align="right" width="200" height="550" src="https://raw.githubusercontent.com/EnthusiastNT/haydee2/main/livesplit_preview.png">

## Features (all optional)

- auto-start the timer when selecting New > Start
- split on item pick up (select which in Settings)
- split on 'Lift Off' ending
- auto-reset the timer on New > Start
- when loading from a save: option to auto-skip
- display current room name in LiveSplit

## Installation 

- download [LiveSplit](https://livesplit.org/downloads/)
- right-click > Edit Splits...
- for Game Name enter 'Haydee 2' (exactly like that for LiveSplit to find it)
- click Activate

## Set-up Splits and Icons

Ready-to-use file with all splits that are also enabled by default in Settings.
Includes subsplits and icons from the game.

- download **[All Splits with Icons](haydee2_splits_icons_newest.lss)** (click Raw > right-click > Save Page As...)
- in LiveSplit right-click > Edit Splits > From File...
- move splits up and down according to your route
- Make sure you have **Subsplits** in your Layout, not just Splits: Edit Layout > (+) > List > Subsplits

## (Manual Set-up)

- right-click > Edit Splits...
- Settings
- select items to split on
- enable Start/Split feature at the top

## (Edit the Script)

You may want to change default settings and/or enhance the auto-splitter:

- download the [ASL Script](haydee2.asl) (click Raw > right-click > Save Page As...)
- right-click > Edit Layout...
- add (+) > Control > Scriptable Auto Splitter
- set Script Path to your .asl file (LiveSplit automatically catches when you change the .asl)
- deactivate the other auto-splitter (don't use two at the same time)
  
## FAQ

Q: It **doesn't split** on some items!?  
A: Make sure you have all items in your Layout checked that you have in your Splits list. Easiest way ist to use above split file and check all default settings (i.e. click Default).

Q: It doesn't **split on what I collected**!?  
A: The auto-splitter is not aware of your Splits list. Make sure to arrange your Splits list in the same order you collect items.

Q: It doesn't **split at the end**!?  
A: You may have more items checked than splits in your list. Make sure you have exactly as many items checked in your Layout as you have in your Splits.

Q: When I load from a save can I start the timer at 0:00?  
A: You can switch to **Real Time** (right-click > Control > Real Time)

Q: The time is not the same as in the game...!?  
A: Make sure to switch to **Game Time** (right-click > Control > Game Time)

Q: What are those -dashes in your splits file?  
A: Indents. They indicate subsplits. Add **subsplits** in Edit Layout > (+) > List > Subsplits

- More about [LiveSplit](https://github.com/LiveSplit)
- How to write an [autosplitter](https://github.com/LiveSplit/LiveSplit.AutoSplitters)

## Thanks

- shoutout to [Coltaho](https://github.com/Coltaho/), his Timespinner .asl was very helpful!
- Thanks to everyone sharing code snippets and insight on the Speedrun Tool Development [Discord](https://discord.gg/MtVmSggpVb), I've used the search function a lot!

## Submit Runs

- https://www.speedrun.com/haydee_2

## Contact

If you encounter any issues or have feature requests please let me know! 

- on Github in the [Issues](https://github.com/EnthusiastNT/haydee2/issues) section
- https://www.speedrun.com/haydee_2 in the forum
- on [Steam](https://steamcommunity.com/sharedfiles/filedetails/?id=2315048067) in the comments
- Enthusiast#2098 on Discord
