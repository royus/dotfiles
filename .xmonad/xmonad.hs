import qualified Data.Map as M
import XMonad
import System.IO
import XMonad.Layout
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Util.Run
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig

myWorkspaces = ["  main  ", "  browser  ", "  work  "]
modm = mod4Mask

keysToRemove x =
	[ (modm .|. shiftMask, xK_c)
	, (modm              , xK_p)
	, (modm .|. shiftMask, xK_Return)
	]
strippedKeys x = foldr M.delete (keys defaultConfig x) (keysToRemove x)

main = do
	xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobar.hs"
	xmonad $ defaultConfig
		{ terminal           = "xterm"
		, modMask            = mod4Mask
		, borderWidth        = 3
		, normalBorderColor  = "#6633FF"
		, focusedBorderColor = "#66FFFF"
		, manageHook         = manageDocks <+> manageHook defaultConfig
		, layoutHook         = spacing 7 $ gaps [(U,13),(D,0),(L,20),(R,20)] $ Tall 1 0.03 0.5
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
		[ ((modm , xK_Return ), spawn "xterm")
		, ((modm , xK_i      ), spawn "chromium")
		, ((modm , xK_p      ), spawn "dmenu_run -fn \"Ricty-13\" -nb black -nf grey -sb grey -sf black")
		, ((modm , xK_c      ), kill)
		-- Brightness Keys
		-- , ((0                       , 0x1008FF02), spawn "xbacklight + 10")
		-- , ((0                       , 0x1008FF03), spawn "xbacklight - 10")
		]

myStartupHook = do
	spawn "feh --bg-fill ~/.background.jpg"
	spawn "stalonetray &"
	spawn "nm-applet &"
	spawn "fcitx &"
