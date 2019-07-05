/decl/cultural_info/location
	desc_type = "Home System"
	secondary_langs = list(
		LANGUAGE_SIGN
	)
	category = TAG_HOMEWORLD
	var/distance = 0
	var/ruling_body = FACTION_SOL_CENTRAL
	var/capital

/decl/cultural_info/location/get_text_details()
	. = list()
	if(!isnull(capital))
		. += "<b>Capital:</b> [capital]."
	if(!isnull(ruling_body))
		. += "<b>Territory:</b> [ruling_body]."
	if(!isnull(distance))
		. += "<b>Distance from Sol:</b> [distance]."
	. += ..()


/decl/cultural_info/ambition
	desc_type = "Ambition"
	category = TAG_AMBITION

/decl/cultural_info/ambition/freedom
	name = AMBITION_FREEDOM
	description = "At the most desperate point of your life, you are approached by a cheerful recruiter looking for colonists for a faraway colony station. She gives a very elegant description \
	of a colony with a culture of freedom and democracy. You have no choice but to accept. Whatever life you were living before was at its end. You are whisked away to a tiny space station \
	as hooded doctors install the neural lace into your head. It will protect you, during the travel. The gateway to your new life is a consuming amber color. You step through it and feel utterly numb."

/decl/cultural_info/ambition/opportunity
	name = AMBITION_OPPORTUNITY
	description = "That thing been chasing for a greater part of your life slips away finally. Your sunken ambition has left you humiliated and without purpose. Those who know you left long ago \
	but a chance encounter forces you into a conversation with a polite recruiter. He can listen to your woes, but he only speaks of one thing. Opportunity. You cant help but accept after he describes \
	a colony where anyone willing to put in the work can make a fortune and live free. You are whisked away to a tiny space station \
	as hooded doctors install the neural lace into your head. It will protect you, during the travel. The gateway to your new life is a consuming amber color. You step through it and feel utterly numb."

/decl/cultural_info/ambition/knowledge
	name = AMBITION_KNOWLEDGE
	description = "No entity  \
	but a chance encounter forces you into a conversation with a polite recruiter. He can listen to your woes, but he only speaks of one thing. Opportunity. You cant help but accept after he describes \
	a colony where anyone willing to put in the work can make a fortune and live free. You are whisked away to a tiny space station \
	as hooded doctors install the neural lace into your head. It will protect you, during the travel. The gateway to your new life is a consuming amber color. You step through it and feel utterly numb."
