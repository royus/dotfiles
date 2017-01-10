import qualified Data.Map as M
import XMonad
import System.IO                       -- for xmobar
import XMonad.Layout
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig

-- myWorkspaces = ["  main  ", "  browser  ", "  work  "]
modm = mod4Mask

keysToRemove x =
	[ (modm .|. shiftMask, xK_c)
	, (modm .|. shiftMask, xK_Return)
	]
strippedKeys x = foldr M.delete (keys defaultConfig x) (keysToRemove x)

main = do
	xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobar.hs"
	xmonad $ defaultConfig
		{ terminal           = "xterm"
		, modMask            = mod4Mask
		, borderWidth        = 5
		, normalBorderColor  = "#6633FF"
		, focusedBorderColor = "#66FFFF"
		, manageHook         = manageDocks <+> manageHook defaultConfig
		, layoutHook         = spacing 10 $ gaps [(U,12),(D,0),(L,30),(R,30)] $ Tall 1 0.03 0.5
		, startupHook = myStartupHook
		}
		`additionalKeys`
		[ ((modm                    , xK_Return ), spawn "xterm")
		, ((modm                    , xK_c      ), kill) -- %! Close the focused window
		, ((modm                    , xK_n      ), spawn "chromium")
        -- Brightness Keys
		-- , ((0                       , 0x1008FF02), spawn "xbacklight + 10")
		-- , ((0                       , 0x1008FF03), spawn "xbacklight - 10")
		]

myStartupHook = do
	spawn "feh --bg-fill ~/.xmonad/.background.jpg"
	spawn "stalonetray &"
	spawn "nm-applet &"
	spawn "fcitx &"
