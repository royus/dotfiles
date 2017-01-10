Config { font = "-misc-fixed-*-*-*-*-13-*-*-*-*-*-*-*"
		, borderColor = "black"
		, border = TopB
		, bgColor = "black"
		, fgColor = "grey"
		, position = TopW L 100
		, commands =
			[ Run Cpu ["-L","10","-H","50","--low","green","--normal","grey","--high","red"] 10
			, Run Memory ["-t","Mem: <usedratio>%"] 10
			-- , Run Battery ["Bat0"] 600
			, Run Battery [] 10
			, Run Com "xmobar-clock-monitor.sh" [] "orgClock" 10
			, Run Com "sh" ["-c", "cat ~/tmp/clocking"] "orgShow" 10
			, Run Date "%a %b %_d %Y %H:%M:%S" "date" 10
			]
		, sepChar = "%"
		, alignSep = "}{"
		, template = "%cpu% | %memory% | %battery% }{ <fc=#ee9a00>%date%</fc>     "
}
