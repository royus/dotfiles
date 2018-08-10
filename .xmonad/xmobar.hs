-- Last Change: 2018/08/06 (Mon) 17:31:47.
Config  { font = "xft:Ricty:size=12"
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
			, Run Battery   [ "--template","Bat: <left>%"
							, "--Low","20"
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
