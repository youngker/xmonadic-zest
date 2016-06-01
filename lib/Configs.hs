module Configs where

import           XMonad
import           XMonad.Layout.PerWorkspace
import           XMonad.Hooks.Place
import           XMonad.Hooks.ManageHelpers
import           XMonad.Prompt
import           XMonad.Prompt.Input
import qualified XMonad.StackSet as W
import           XMonad.Util.Scratchpad

import           Data.Maybe
import           System.Exit
import qualified Data.Map as M

import           Layouts

-- Global for browser
myBrowser :: String
myBrowser = "google-chrome-beta"

myMailClient :: String
myMailClient = "thunderbird-bin"

-- special command prompt
commandPrompt :: XPConfig -> String -> M.Map String (X ()) -> X ()
commandPrompt c p m = inputPromptWithCompl c p (mkComplFunFromList (M.keys m)) ?+ (\k -> fromMaybe (return ()) (M.lookup k m))

commands :: M.Map String (X ())
commands = M.fromList
  [ ("logout"       , io    exitSuccess)
  , ("lock"         , spawn "xscreensaver-command -lock")
  , ("suspend"      , spawn "xscreensaver-command -lock && sleep 2 && sudo systemctl suspend -i")
  , ("shutdown"     , spawn "sleep 2 && systemctl poweroff")
  , ("restart"      , spawn "sleep 2 && systemctl reboot")
  , ("sleep"        , spawn "xscreensaver-command -lock && sleep 1 && sudo pm-suspend")
  ]

-- shellprompt config
fireSPConfig = def
  { bgColor             = colorFocusBG,
    fgColor             = colorNormalFG,
    bgHLight            = colorNormalBG,
    fgHLight            = colorFocusFG,
    borderColor         = "black",
    promptBorderWidth   = 0,
    position            = Bottom,
    height              = 12,
    historySize         = 256,
    defaultText         = "",
    autoComplete        = Nothing
  }

myWorkspaces :: [String]
myWorkspaces    = ["1: Browser","2: Editor","3: Terminal","4: Music","5: Files","6: Video","7","8","9", "IM", "Mail"]

myFullscreenHooks = [ composeOne [ isFullscreen -?> doFullFloat  ], resource =? "synapse" --> doIgnore ]

myPlacement = withGaps (0,0,0,0) (smart (0.5,0.5))

myManagementHooks = composeAll . concat $
    [ [ className   =? c --> doFloat                    | c <- myFloats]
    , [ title       =? t --> doFloat                    | t <- myOtherFloats]
    , [ className   =? c --> doF (W.shift "1: Browser") | c <- [myBrowser]]
    , [ className   =? c --> doF (W.shift "2: Emacs")   | c <- ["Emacs"]]
    , [ className   =? c --> doF (W.shift "4: Music")   | c <- ["Rhythmbox"] ]
    , [ className   =? c --> doF (W.shift "Mail"    )   | c <- ["Thunderbird"] ]
    , [ className   =? c --> doF (W.shift "IM"    )     | c <- imApps ]
    ]
  where myFloats      = ["MPlayer", "Gimp", "chrome-app-list", "Synapse"]
        myOtherFloats = ["alsamixer", "chrome-app-list", "cappl", "htop", "nmtui"]
        imApps        = ["Skype", "Pidgin"]

-- These layouts are stored in the Custom.Layouts module
myLayoutHook = im normal where
    normal   = myLayout
    im       = onWorkspace "im" imLayout

manageScratchPad :: ManageHook
manageScratchPad = scratchpadManageHook (W.RationalRect l t w h)
  where
    h = 0.1     -- terminal height, 10%
    w = 1       -- terminal width, 100%
    t = 1 - h   -- distance from top edge, 90%
    l = 1 - w   -- distance from left edge, 0%

-- color definitions
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#0000ff"

-- colors for shellprompt
colorNormalFG = "#B6B4B8"
colorNormalBG = "#2F2E2B"
colorNormalBO = "#1C2636"
colorFocusFG = "#FFFFFF"
colorFocusBG = "#2F2E2B"
colorFocusBO = "#FF0000"
colorOtherFG = "#707070"
colorOtherBG = "#2F2E2B"
