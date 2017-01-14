Config  { font = "xft:Ricty"
		, borderColor = "black"
		, border = TopB
		, bgColor = "black"
		, fgColor = "grey"
		, position = TopW L 100
		, commands =
			[ Run Cpu       [ "--Low","10"
							, "--High","50"
							, "--low","green"
							, "--normal","grey"
							, "--high","red"
							] 10
			, Run Memory    [ "--template","Mem: <usedratio>%"
							, "--Low","10"
							, "--High","50"
							, "--low","green"
							, "--normal","grey"
							, "--high","red"
							] 10
			, Run Battery   [ "--template","Batt: <left>%"
							, "--Low","49"
							, "--High","80"
							, "--low","red"
							, "--normal","grey"
							, "--high","green"
							] 10
			, Run Date "%a %b %_d %Y %H:%M:%S" "date" 10
			, Run StdinReader
			]
		, sepChar = "%"
		, alignSep = "}{"
		, template = "%cpu%  %memory%  %battery% }%StdinReader%{ <fc=orange>%date%</fc>     "
}
