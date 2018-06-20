#!/usr/bin/env bash
set -e

FAILED=0
shopt -s globstar

exactly() { # exactly N name search [mode]
	count="$1"
	name="$2"
	search="$3"
	mode="${4:--E}"

	num="$(grep "$mode" "$search" **/*.dm | wc -l)"

	if [ $num -eq $count ]; then
		echo "$num $name"
	else
		echo "$(tput setaf 9)$num $name (expecting exactly $count)$(tput sgr0)"
		echo "If this is not in error, you can change the value in test\check-paths.sh"
		FAILED=1
	fi
}

# With the potential exception of << if you increase any of these numbers you're probably doing it wrong
exactly 0 "escapes" '\\\\(red|blue|green|black|b|i[^mc])'
exactly 7 "Del()s" '\WDel\('
exactly 2 "/atom text paths" '"/atom'
exactly 11 "/area text paths" '"/area'
exactly 2 "/datum text paths" '"/datum'
exactly 2 "/mob text paths" '"/mob'
exactly 13 "/obj text paths" '"/obj'
exactly 8 "/turf text paths" '"/turf'
exactly 8 "world<< uses" 'world<<|world[[:space:]]<<'
exactly 46 "world.log<< uses" 'world.log<<|world.log[[:space:]]<<'
exactly 773 "<< uses" '(?<!<)<<(?!<)' -P
exactly 0 "incorrect indentations" '^( {4,})' -P
exactly 38 "text2path uses" 'text2path'
# With the potential exception of << if you increase any of these numbers you're probably doing it wrong

num=`find ./html/changelogs -not -name "*.yml" | wc -l`
echo "$num non-yml files (expecting exactly 2)"
[ $num -eq 2 ] || FAILED=1

exit $FAILED
