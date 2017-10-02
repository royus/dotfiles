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
		-- `additionalKeys`
		-- [ ((modMask,               xK_i      ), spawn "chromium")
		-- , ((modMask,               xK_p      ), spawn "dmenu_run -fn \"Ricty-14\" -nb black -nf grey -sb grey -sf black")
		-- , ((modMask,               xK_Tab    ), nextMatch Forward  (return True))
		-- , ((modMask .|. shiftMask, xK_Tab    ), nextMatch Backward (return True))
		-- , ((modMask .|. shiftMask, xK_l      ), spawn "xbacklight + 5")
		-- , ((modMask .|. shiftMask, xK_d      ), spawn "xbacklight - 5")
		-- ]

myStartupHook = do
	spawn "feh --bg-fill ~/.background.jpg"
	spawn "stalonetray &"
	spawn "nm-applet &"
	spawn "fcitx &"
	spawn "xcompmgr &"
	spawn "transset-df -a 0.9 >/dev/null"

