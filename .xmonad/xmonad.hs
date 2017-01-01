import XMonad
import XMonad.Layout
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.ManageDocks


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
		}
-- avoidStruts
