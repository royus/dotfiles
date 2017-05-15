import qualified Data.Map as M
import XMonad
import System.IO
import XMonad.Layout
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Util.Run
import XMonad.Hooks.DynamicLog
-- import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig
import XMonad.Actions.GroupNavigation

myWorkspaces = ["1: main", "2: browser", "3: work", "4: media"]
modm = mod1Mask

keysToRemove x =
	[ (modm              , xK_p)
	, (modm .|. shiftMask, xK_Return)
	]
strippedKeys x = foldr M.delete (keys defaultConfig x) (keysToRemove x)

main = do
	xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobar.hs"
	xmonad $ defaultConfig
		{ terminal           = "xterm"
		, workspaces         = myWorkspaces
		-- , modMask            = mod4Mask
		, borderWidth        = 3
		, normalBorderColor  = "#6633FF"
		, focusedBorderColor = "#66FFFF"
		, manageHook         = manageDocks <+> manageHook defaultConfig
		, layoutHook         = spacing 4 $ gaps [(U,20),(D,10),(L,23),(R,23)] $ Tall 1 0.03 0.5
		, logHook            = dynamicLogWithPP $ xmobarPP
			{ ppOrder           = \(ws:l:t:_)  -> [ws,t]
			, ppOutput          = hPutStrLn xmproc
			, ppTitle = xmobarColor "green" "".shorten 50
			, ppWsSep           = " "
			, ppSep             = "  "
			}
		, startupHook = myStartupHook
		}
		`additionalKeys`
		[ ((modm,               xK_Return ), spawn "xterm")
		, ((modm,               xK_i      ), spawn "chromium")
		, ((modm,               xK_p      ), spawn "dmenu_run -fn \"Ricty-14\" -nb black -nf grey -sb grey -sf black")
		, ((modm,               xK_Tab    ), nextMatch Forward   (return True))
		, ((modm .|. shiftMask, xK_Tab    ), nextMatch Backward (return True))
		, ((modm .|. shiftMask, xK_l      ), spawn "xbacklight + 5")
		, ((modm .|. shiftMask, xK_d      ), spawn "xbacklight - 5")
		]
		-- , layoutHook         = spacing 4 $ gaps [(U,16),(D,2),(L,21),(R,21)] $ Tall 1 0.03 0.5

myStartupHook = do
	spawn "feh --bg-fill ~/.background.jpg"
	spawn "stalonetray &"
	spawn "nm-applet &"
	spawn "fcitx &"
	spawn "xcompmgr &"
