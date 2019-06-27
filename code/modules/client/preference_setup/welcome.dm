
/datum/preferences
	var/welcome_accept = 0

/datum/category_item/player_setup_item/welcome
	name = "Welcome to Persistent Station 13!"
	sort_order = 1

/datum/category_item/player_setup_item/welcome/content()
	. = list()
	. += "<center><h1>Welcome to Persistence SS13!</h1></center><br><hr><br>"
	. += "<font size=4 color='orange'>"
	. += "An entirely unique storytelling community. In Persistence, the entire game-world and every character within it saves. Our community members create structures, organizations and unique characters to bring the shared universe into vibrant life."
	. += "An elected government creates laws that hires police to enforce them while collecting taxes from private businesses that are competing in the lower floors of the Nexus City Space Station.<br><br>"
	. += "Members of our community are free to create conflict and excitement as long as they play reasonable characters and work with our excellent administration staff to make sure that conflict helps create a good story for everyone."
	. += "Relax and have fun on your first day. You are a new immigrant to Nexus City and you might need to spend some time looking for a job or some friends.<br>"
	. += "Persistence is the product of dozens of developers, administrators and community leaders spending years to put together the best community that I've ever been a part of. I'm really glad that you get a chance to play this totally unique game."
	. += "<br><b><i>Brawler, Lead Developer of Persistence</i></b>"
	. += "</font><br><br>"
	. += "<a href='https://discord.gg/53YgfNU'target='_blank'>Join the Discord</a><br>The Discord is where the majority of OOC discussion takes place and tons of helpful players will tell you all about how to play persistence and what makes it different."
	if(pref.welcome_accept)
		. += "<br><br><br><b>You are ready to create a legacy in our shared universe.</b>"
	else
		. += "<br><br><br><a href='?src=\ref[src];accept_welcome=1'>I am ready to join Persistence</a>"
	. = jointext(.,null)


/datum/category_item/player_setup_item/welcome/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["accept_welcome"])
		pref.welcome_accept = 1
		return TOPIC_REFRESH
	. = ..()