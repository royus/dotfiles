--Last Change: 2018/08/23 (Thu) 10:16:46.

-------------------------------------------------------------------------------
--                  __  ____  __                       _                     --
--                  \ \/ /  \/  | ___  _ __   __ _  __| |                    --
--                   \  /| |\/| |/ _ \| '_ \ / _` |/ _` |                    --
--                   /  \| |  | | (_) | | | | (_| | (_| |                    --
--                  /_/\_\_|  |_|\___/|_| |_|\__,_|\__,_|                    --
--                                                                           --
-------------------------------------------------------------------------------

import XMonad
import System.IO
import XMonad.Layout
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run
import XMonad.Util.EZConfig
import XMonad.Actions.GroupNavigation

main =do
	xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobar.hs"
	xmonad $ defaultConfig
		{ terminal    = "termite"
		, workspaces= ["1: main", "2: browser", "3: work", "4: media"]
		, modMask     = mod1Mask
		, borderWidth = 3
		, normalBorderColor  = "#6633FF"
		, focusedBorderColor = "#66FFFF"
		, manageHook         = manageDocks <+> manageHook defaultConfig
		, layoutHook         = spacing 4 $ gaps [(U,20),(D,12),(L,23),(R,23)] $ Tall 1 0.03 0.5
		, logHook            = dynamicLogWithPP $ xmobarPP
			{ ppOrder           = \(ws:l:t:_)  -> [ws,t]
			, ppOutput          = hPutStrLn xmproc
			, ppTitle = xmobarColor "green" "".shorten 50
			, ppWsSep           = " "
			, ppSep             = "  "
			}
		, startupHook = myStartupHook
		}

		`additionalKeysP`
		[ ("M1-i"  , spawn "chromium")
		, ("M1-p"  , spawn "dmenu_run -fn \"Ricty-12\" -nb black -nf grey -sb grey -sf black")
		-- , ("M1-<Return>"  , spawn "termite")
		-- , ("M1-t", nextMatch Forward  (return True))
		-- , ("M1-S-t", nextMatch Backward (return True))
		, ("M1-S-l"  , spawn "sh ~/lighter.sh")
		, ("M1-S-d"  , spawn "sh ~/darker.sh")
		]

myStartupHook = do
	spawn "xcompmgr &"
	spawn "feh --bg-fill ~/.background.jpg"
	spawn "stalonetray &"
	spawn "nm-applet &"
	spawn "fcitx &"
	spawn "exec xset m 4/3 4"
--
