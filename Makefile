gen: 
	~/pkl eval pkls/Project.pkl > Project.yml
	~/pkl eval pkls/baseConfig.pkl > configs/base.xcconfig
	~/pkl eval pkls/InfoPlist.pkl > Source/Supporting\ Files/Info.plist
	xcodegen
start:
	xed .
