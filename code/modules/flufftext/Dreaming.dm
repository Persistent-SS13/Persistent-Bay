
var/list/dreams = list(
	""Welcome to The NSS Vignette!"",""A whole new frontier..."",""Life is transient, but so is death."",
	"The gateway annihilates your body, spreading it across the cosmos...","The stars chime like struck bells.",
	"You hear a distant bark...","A faraway sun smiles at you.","Something whispers into your ear...","Xentec...?","Your lungs!",
	"You hear a sinister hiss...","The computer beeps, and then goes black.",
	"A great light from the skies eviscerates an entire colony...",The Darkness...",""Love..."","""Close your eyes."",
	"Lush forests...",""Want another drink?"","The airlock explodes!","The slime envelops your head...",""WAKE UP!"","Snow falls...",
	"The shrine glows with an eerie light...",""Your employment on this station has come to an end."","Blood stains...","Find the truth.",
	"You sign your name on the dotted line.","Exotic scents...","The tastes of another planet...","Luxurious silks...",
	""Hyperion, Divinity in innovation!"",""Bluespace is perfectly safe!"",""Green planet? We'll just take another!"",
	""What's a Vox?"","An explosion rocks the station!","You reach a hand up to feel your exposed brain...",""I'm not scared!",
	"The air alarm turns red...","A claw slashes your face!","A shooting star passes by...", "You feel trapped.",
	"A feeling of impending doom rests heavily on you...",""You can do it!"","The thing stares at you, an eerie smile on it's 'face'.",
	"You wake up...","You fall asleep...","You take one more out of the packet...","You feel at peace with the universe.",
	""I did not have sexual relations with that Unathi!"","Something is missing...","This journey will never end.","Sleep...",
	"Zzz...","It's so dark...","...","BOOM!","ZAP!","Sss!","Whoosh!",""No!"",""This was a mistake..."","You hear hooves.","It's cold...",
	"the virologist","the roboticist","a chef","the bartender","a chaplain","a librarian","a mouse",
	"You hear a loud buzz!","","a smokey room","a voice","the cold","a mouse","an operating table","the rain","a skrell",
	"an unathi","a tajaran","the ai core","a beaker of strange liquid","the supermatter"
	)

mob/living/carbon/proc/dream()
	dreaming = 1

	spawn(0)
		for(var/i = rand(1,4),i > 0, i--)
			to_chat(src, "<span class='notice'><i>[pick(dreams)]</i></span>")
			sleep(rand(40,70))
			if(paralysis <= 0)
				dreaming = 0
				return 0
		dreaming = 0
		return 1

mob/living/carbon/proc/handle_dreams()
	if(client && !dreaming && prob(5))
		dream()

mob/living/carbon/var/dreaming = 0
