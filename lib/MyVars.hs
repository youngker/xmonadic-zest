module MyVars where

import XMonad

data Action = Increase | Decrease

myModMask :: KeyMask
myModMask = mod3Mask

myAppLauncherApp :: String
myAppLauncherApp = "rofi -show run -lines 6 -eh 1 -width 100 -padding 100 -opacity \"85\" -bw 0 -color-normal \"#2f343f,#f9f9f9,#2f343f,#2f343f,#9575cd\" -color-window \"#2f343f,#2f343f,#2f343f\""

myBrowserApp :: String
myBrowserApp = "google-chrome-beta"

myTerminalApp :: String
myTerminalApp = "konsole"

myEditorApp :: String
myEditorApp = "emc"

myMailClient :: String
myMailClient = "thunderbird-bin"

volumeAction :: Action -> String
volumeAction Increase = "amixer --card 1 -q set PCM 5%+"
volumeAction Decrease = "amixer --card 1 -q set PCM 5%-"

volumeMasterAction :: Action -> String
volumeMasterAction Increase = "amixer --card 1 -q set Master 5%+"
volumeMasterAction Decrease = "amixer --card 1 -q set Master 5%-"

brightnessAction :: Action -> String
brightnessAction Increase = "xbacklight -steps 1 -time 1 -inc 8"
brightnessAction Decrease = "xbacklight -steps 1 -time 1 -dec 6"
