module Startup where

import           XMonad
import           XMonad.Hooks.EwmhDesktops
import           XMonad.Util.Cursor
import           XMonad.Util.SpawnOnce
import qualified XMonad.StackSet as W

-- | Sleeps for provided time, then
--   Kills running instances of program (if greedyKill)
--   Then starts the program if greedyKill was enabled, or
--   if process wasn't running already
delayedStartOnce :: Bool -> Int -> String -> X ()
delayedStartOnce greedyKill time run =
  let execName = takeWhile (/= ' ') run
      sleep = "sleep " ++ show time
      kills = "pkill " ++ execName
      howToRun = "bash -c \"" ++ run ++ "&\""
      ifkill = "if not pgrep " ++ execName ++ "; then " ++ howToRun ++ "; fi;"
      ands = "; "
      wrap str = "bash -c '" ++ str ++ "'"
  in if greedyKill then
      spawn $ wrap $ "(" ++ sleep ++ ands ++ kills ++ ands ++ howToRun ++ ") &"
    else
      spawn $ wrap $ "(" ++ sleep ++ ands ++ ifkill ++ ") &"

myStartup :: X ()
myStartup = do
  ewmhDesktopsStartup
  setDefaultCursor xC_left_ptr
  -- delayedStartOnce True 00 "taffybar"
  delayedStartOnce True 00 "compton"
  -- delayedStartOnce True 10 "pasystray"
  -- delayedStartOnce True 15 "thunderbird"
  -- delayedStartOnce False 30 "xscreensaver -no-splash"
  -- delayedStartOnce False 05 "emacs --daemon"
  delayedStartOnce True 01 "xmodmap ~/.Xmodmap"
  delayedStartOnce True 02 "xcape -e 'Hyper_L=Tab'"
  -- delayedStartOnce True 02 "urxvtd --quiet --opendisplay --fork"
  delayedStartOnce True 02 "konsole"
  -- delayedStartOnce False 30 "watch -n 120 ~/.myscripts/batteryNotifier.sh"
  -- spawnOnce "~/.myscripts/blueoff &"
  spawn "feh --bg-fill /usr/share/backgrounds/wallpaper1.jpg &"
  spawn "xrdb ~/.Xresources &"
  -- spawn "pcmanfm --desktop &"

spawnToWorkspace :: String -> String -> X ()
spawnToWorkspace program workspace = do
                                      spawnOnce program
                                      windows $ W.greedyView workspace
