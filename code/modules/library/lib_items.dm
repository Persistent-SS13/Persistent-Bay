/* Library Items
 *
 * Contains:
 *		Bookcase
 *		Book
 */


/*
 * Bookcase
 */

/obj/structure/bookcase
	name = "bookcase"
	icon = 'icons/obj/library.dmi'
	icon_state = "book-0"
	anchored = 1
	density = 1
	opacity = 1
	obj_flags = OBJ_FLAG_ANCHORABLE

/obj/structure/bookcase/Initialize()
	for(var/obj/item/I in loc)
		if(istype(I, /obj/item/weapon/book))
			I.forceMove(src)
	update_icon()
	. = ..()

/obj/structure/bookcase/attackby(obj/O as obj, mob/user as mob)
	if(istype(O, /obj/item/weapon/book))
		if(!user.unEquip(O, src))
			return
		update_icon()
	else if(istype(O, /obj/item/weapon/pen))
		var/newname = sanitizeSafe(input("What would you like to title this bookshelf?"), MAX_NAME_LEN)
		if(!newname)
			return
		else
			SetName("bookcase ([newname])")
	else if(isScrewdriver(O))
		playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
		to_chat(user, "<span class='notice'>You begin dismantling \the [src].</span>")
		if(do_after(user,25,src))
			to_chat(user, "<span class='notice'>You dismantle \the [src].</span>")
			new/obj/item/stack/material/wood(get_turf(src), 5)
			for(var/obj/item/weapon/book/b in contents)
				b.dropInto(loc)
			qdel(src)

	else
		..()
	return

/obj/structure/bookcase/attack_hand(var/mob/user as mob)
	if(contents.len)
		var/obj/item/weapon/book/choice = input("Which book would you like to remove from the shelf?") as null|obj in contents
		if(choice)
			if(!CanPhysicallyInteract(user))
				return
			if(ishuman(user))
				if(!user.get_active_hand())
					user.put_in_hands(choice)
			else
				choice.dropInto(loc)
			update_icon()

/obj/structure/bookcase/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/obj/item/weapon/book/b in contents)
				qdel(b)
			qdel(src)
			return
		if(2.0)
			for(var/obj/item/weapon/book/b in contents)
				if (prob(50)) b.dropInto(loc)
				else qdel(b)
			qdel(src)
			return
		if(3.0)
			if (prob(50))
				for(var/obj/item/weapon/book/b in contents)
					b.dropInto(loc)
				qdel(src)
			return
		else
	return

/obj/structure/bookcase/on_update_icon()
	if(contents.len < 5)
		icon_state = "book-[contents.len]"
	else
		icon_state = "book-5"



/obj/structure/bookcase/manuals/medical
	name = "Medical Manuals bookcase"

	New()
		..()
		new /obj/item/weapon/book/manual/medical_cloning(src)
		new /obj/item/weapon/book/manual/medical_diagnostics_manual(src)
		new /obj/item/weapon/book/manual/medical_diagnostics_manual(src)
		new /obj/item/weapon/book/manual/medical_diagnostics_manual(src)
		update_icon()


/obj/structure/bookcase/manuals/engineering
	name = "Engineering Manuals bookcase"

	New()
		..()
		new /obj/item/weapon/book/manual/engineering_construction(src)
		new /obj/item/weapon/book/manual/engineering_particle_accelerator(src)
		new /obj/item/weapon/book/manual/engineering_hacking(src)
		new /obj/item/weapon/book/manual/engineering_guide(src)
		new /obj/item/weapon/book/manual/atmospipes(src)
		new /obj/item/weapon/book/manual/engineering_singularity_safety(src)
		new /obj/item/weapon/book/manual/evaguide(src)
		update_icon()

/obj/structure/bookcase/manuals/research_and_development
	name = "R&D Manuals bookcase"

	New()
		..()
		new /obj/item/weapon/book/manual/research_and_development(src)
		update_icon()


/*
 * Book
 */
/obj/item/weapon/book
	name = "book"
	icon = 'icons/obj/library.dmi'
	icon_state ="book"
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL		 //upped to three because books are, y'know, pretty big. (and you could hide them inside eachother recursively forever)
	attack_verb = list("bashed", "whacked", "educated")
	var/dat			 // Actual page content
	var/author		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	var/author_real // who bound the thing, for admins
	var/unique = 0   // 0 - Normal book, 1 - Should not be treated as normal book, unable to be copied, unable to be modified
	var/title		 // The real name of the book.
	var/carved = 0	 // Has the book been hollowed out for use as a secret storage item?
	var/obj/item/store	//What's in the book?

/obj/item/weapon/book/attack_self(var/mob/user as mob)
	if(carved)
		if(store)
			to_chat(user, "<span class='notice'>[store] falls out of [title]!</span>")
			store.dropInto(loc)
			store = null
			return
		else
			to_chat(user, "<span class='notice'>The pages of [title] have been cut out!</span>")
			return
	if(src.dat)
		user << browse(dat, "window=book;size=1000x550")
		user.visible_message("[user] opens a book titled \"[src.title]\" and begins reading intently.")
		onclose(user, "book")
	else
		to_chat(user, "This book is completely blank!")

/obj/item/weapon/book/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(carved == 1)
		if(!store)
			if(W.w_class < ITEM_SIZE_NORMAL)
				if(!user.unEquip(W, src))
					return
				store = W
				to_chat(user, "<span class='notice'>You put [W] in [title].</span>")
				return
			else
				to_chat(user, "<span class='notice'>[W] won't fit in [title].</span>")
				return
		else
			to_chat(user, "<span class='notice'>There's already something in [title]!</span>")
			return
	if(istype(W, /obj/item/weapon/pen))
		if(unique)
			to_chat(user, "These pages don't seem to take the ink well. Looks like you can't modify it.")
			return
		var/choice = input("What would you like to change?") in list("Title", "Contents", "Author", "Cancel")
		switch(choice)
			if("Title")
				var/newtitle = reject_bad_text(sanitizeSafe(input("Write a new title:")))
				if(!newtitle)
					to_chat(usr, "The title is invalid.")
					return
				else
					src.SetName(newtitle)
					src.title = newtitle
			if("Contents")
				var/content = sanitize(input("Write your book's contents (HTML NOT allowed):") as message|null, MAX_BOOK_MESSAGE_LEN)
				if(!content)
					to_chat(usr, "The content is invalid.")
					return
				else
					src.dat += content
			if("Author")
				var/newauthor = sanitize(input(usr, "Write the author's name:"))
				if(!newauthor)
					to_chat(usr, "The name is invalid.")
					return
				else
					src.author = newauthor
			else
				return
	else if(istype(W, /obj/item/weapon/material/knife) || isWirecutter(W))
		if(carved)	return
		to_chat(user, "<span class='notice'>You begin to carve out [title].</span>")
		if(do_after(user, 30, src))
			to_chat(user, "<span class='notice'>You carve out the pages from [title]! You didn't want to read it anyway.</span>")
			carved = 1
			return
	else
		..()

/obj/item/weapon/book/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(user.zone_sel.selecting == BP_EYES)
		if(carved)
			to_chat(user, "The book is carved out and so you cannot show its contents.")
			return
		user.visible_message("<span class='notice'>You open up the book and show it to [M]. </span>", \
			"<span class='notice'> [user] opens up a book and shows it to [M]. </span>")
		M << browse("<i>Author: [author].</i><br><br>" + "[dat]", "window=book;size=1000x550")
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN) //to prevent spam


/obj/item/weapon/paper/guidetonexusone
	info = "<br>\
		<center>\
			<img src = nfrlogo.png>\
			<br>\
			<h1>Understanding Nexus City</h1><br>\
			<span class='small-text'>A guide to the government and economy of Nexus City.</span><br>\
			<br>\
			<span class='large-text'>Chapter 1: Introduction<br>\
			Chapter 2: Government<br>\
			Chapter 3: Business and Economy<br>\
			Chapter 4: Government In-Depth<br>\
			Chapter 5: Business and Economy In-Depth<br>\
			Chapter 6: The City Charter</span>\
		</center><br>\
		<br>"

/obj/item/weapon/paper/guidetonexustwo
	info = "<h2>Chapter 1 - Introduction</h2><br>\
		<br>\
		Thank you for your interest in the structure, culture, economy and government of Nexus City. Your decision to read this guidebook shows your commitment to starting your life anew!<br>\
		<br>\
		If you are reading this, you are now a resident or citizen of Nexus City. You have been provided with an allowance of 1000$$, $$ being the symbol for our local currency the Centera. Utilizing this guide, the 1000$$ will go a long ways in starting your life in the city.<br>\
		<br>\
		The priority of new residents of the city should be finding employment in a corporation or the government of the city. There are many opportunities available, including business ownership, politics, government service and employment.<br>\
		<br>\
		It is recommended you read the entire guidebook, however the government and business and economy chapters are split into a summary and in-depth chapters to allow for easier reading.<br>\
		<br>"

/obj/item/weapon/paper/guidetonexusthree
	info = "<h2>Chapter 2 - Government</h2><br>\
		<br>\
		The government of Nexus City is governed by the Nexus City Charter, which is included in the final chapter.<br>\
		<br>\
		The city government is democratic and representative in nature and function, with an elected City Council and Governor. Judges of the city are appointed by the Governor with approval of the City Council.<br>\
		<br>\
		City councilors and the Governor serve two week terms, and are elected on alternating Saturdays between 10:00AM and 10:00PM. There is a fee of 500$$ for entering elections.<br>\
		<br>\
		The City Council is responsible for the creation of all new laws, including tax law, civil law and criminal law. The Governor is responsible for enforcing the laws of the city and appointing judges. Judges of the city are responsible for presiding over trials and managing the citizenship policy of the city.<br>\
		<br>\
		The city government is divided into such units that are created by the City Council and Governor, the Nexus City Police are the primary law enforcement and defense force of the city. The Nexus City Police are headed by a Chief of Police.<br>\
		<br>\
		The city has a tiered citizenship structure. Citizens have full political and voting rights under the city government, but pay full income taxes. Residents of the city cannot vote but pay only half of the income tax a citizen does. Judges are responsible for managing citizenship.<br>\
		<br>\
		The city itself is split into three districts, the Government District, the Citizen District and the Resident District. The government is responsible for creating laws regarding the districts. Citizens and residents have their cryopods in their respective areas.<br>\
		<br>"

/obj/item/weapon/paper/guidetonexusfour
	info = "<h2>Chapter 3 - Business and Economy</h2><br>\
		<br>\
		The primary economics actors in Nexus City are businesses.<br>\
		<br>\
		Businesses in the city are controlled by their stockholders, a single stock in a business represents 1% ownership in the business, meaning each business is composed of 100 stocks divided into a maximum of 100 owners.<br>\
		<br>\
		Businesses are divided into six general categories: engineering, retail, service, medical, media and mining. Each category is further divided into two specializations. The category and specialization determines which type of fabricators a business can use, how many fabricators a business can operate, how many shuttles a business can have, the amount of land a business can own and the technology easily accessible by the business.<br>\
		<br>\
		Business categories and specializations, while somewhat limiting, do not prevent businesses from doing things outside of the standard definition of their category. For example, there is no defined security category or specialization, so a security corporation could operate under any category.<br>\
		<br>\
		The total amount of stocks held by a person is restricted by Nexus City Account level. Nexus City Account level represents economic privileges held by a resident or citizen. A base level Nexus City Account can own a total of 125 shares. The amount of personal shuttles owned by a person is also limited by Nexus City Account level, and starts at 0.<br>\
		<br>\
		The primary means of material trade between corporations is the material market. The material market allows businesses to easily list materials to purchase or sell. The options of the material market allow a corporation to list buy and sell orders, to quickly purchase a material or to quickly sell materials based on average market value.<br>\
		<br>\
		Corporate tax rate can either be progressive or flat. Progressive corporate tax exists in four brackets and are based on the total amount of money in a business account.<br>\
		<br>\
		Businesses have different costs to create depending on business type.<br>\
		<br>"

/obj/item/weapon/paper/guidetonexusfive
	info = "<h2>Chapter 4 - Government In-Depth</h2><br>\
		Read this chapter if you would like to further understand the operations of the Nexus City Government, including the Governorship, the City Council, the Judges, Elections and Citizenship.<br>\
		<h3>The Governor</h3><br>\
		The Governor has multiple specific powers. These powers are the vetoing of City Council laws, the creation of Executive Policy, the general management of the City Government and the appointment of judges.<br>\
		<br>\
		The Governor can use the Nexus City Governor Control program to perform all of his actions.<br>\
		<br>\
		The program allows the Governor to veto proposals in the City Council, to create executive policy, to view and repeal executive policy and to nominate judges.<br>\
		<br>\
		To veto a law that has passed the City Council, simply open the Governors Desk tab of the program.<br>\
		<br>\
		To issue an executive policy, enter the New Executive Policy tab and have a physical paper prepared with the policy on it for the program to scan. To repeal an existing executive policy, simply enter the View/Repeal Executive Policies tab.<br>\
		<br>\
		To nominate a new judge, simply enter the Nominate Judge tab.<br>\
		<br>\
		<h3>The City Council</h3><br>\
		The City Council has multiple specific powers. These powers are the creation of law in the areas of tax law, civil law and criminal law and the approval of judges appointed by the Governor.<br>\
		<br>\
		There are five positions on the council, each position on the council has a unique title that does not inherently reflect their authority. The authority of the councilors are, legally, identical. The five positions within the City Council are: the Councillor of Justice and Criminal Matters, the Councillor of Budget and Tax Measures, the Councillor of Commerce and Business Relations, the Councillor for Culture and Ethical Oversight and the Councillor for Domestic Affairs.<br>\
		<br>\
		Each individual councillor is encouraged to pay special attention to the areas that their title concerns, however it is not mandatory. All councillors have equal voting powers on all measures pending the Council.<br>\
		<br>\
		As a councillor, you can present laws to be voted on by the council. All laws require a sponsor to be presented, and are presented through the Nexus City Council Control program. To prepare a law to be presented, print it out or write it on a piece of paper, the program requires a physical paper to be scanned. The exception to this is tax laws, which are designed in the program itself.<br>\
		<br>\
		<h3>The Judiciary</h3><br>\
		The judges of Nexus City have multiple specific powers. These powers are the scheduling of trials, the rendering of verdicts and the management of citizenship status.<br>\
		<br>\
		To perform any action as a judge, use the Nexus City Judge Controls program.<br>\
		<br>\
		To schedule a trial as a judge, use the program to set the trial title, plaintiff, defendant and month, day and hour.<br>\
		<br>\
		Verdicts are separate than trials, although the end of a trial will most commonly result in a verdict, the scheduling of a trial is only for the purposes of alerting the parties of when to appear, and to announce the trial to the public. Judges may issue verdicts without scheduling or participating in a trial if needed, such in matters relating to citizenship. The adjustment of citizenship is through the rendering of a verdict. Judges may set someone as a citizen, resident or prisoner.<br>\
		<br>\
		To render a verdict, the same system as executive policy and laws are used. A physical paper must be prepared and scanned by the program.<br>\
		<br>\
		<h3>Elections</h3><br>\
		Elections happen once a week on Saturdays between 10:00AM and 10:00PM. Elections for Governor and City Council are staggered, such that the election for Governor and City Councilor are not during the same week. All councillors are elected at the same time.<br>\
		<br>\
		To view the candidates for office, open the Nexus City Election and Nominations program. The program will tell you the time of the upcoming elections, and will list the six elected offices. You can click on each office to see the individual candidates.<br>\
		<br>\
		When entering an election to gain political office, there is a fee of 500$$. After paying the 500$$ fee, you are able to enter a description of your candidacy which can be a maximum of 300 characters. After finalizing your candidacy, you will be a candidate for your selected office. You may only run for a single office at a time.<br>\
		<br>\
		<h3>Citizenship</h3><br>\
		Citizenship is managed by the various judges of Nexus City. Judges can adjust citizenship through the rendering of a verdict, regardless of an existing trial. The lawfulness of a judge adjusting citizenship is dependent on law.<br>\
		<br>\
		The citizenship structure allows for three 'types' of citizens. Citizens, residents and prisoners. Citizens represent people with full political rights under the city, residents represent people with reduced political rights under the city, and prisoners are either incarcerated or otherwise punished by the city.<br>\
		<br>\
		Law determines the difference between citizens, residents and prisoners other than the fact that citizens can vote and pay full income tax, and residents do neither.<br>\
		<br>"

/obj/item/weapon/paper/guidetonexussix
	info = "<h2>Chapter 5 - Business and Economy In-Depth</h2><br>\
		Read this chapter if you wish to further understand the operations of businesses within Nexus City.<br>\
		<h3>Business Creation</h3><br>\
		Any person is eligible to create a business. Business registration can either be done by a single person, or by multiple people.<br>\
		<br>\
		The business creation process is simple. To begin, a single person must initiate the process on a console. After selecting the type and specialization of the business, the person will have the opportunity to print out contracts to fund the business. Contracts are printed out with one, the total amount of money being promised to create the business, and 2, the total shares being granted in return. For example, a contract could be printed that says the signer will give the business 100$$ in exchange for 22 shares in the business.<br>\
		<br>\
		Using this method, the initiating party must completely fund the starting cost of a business. Money gathered in excess of this starting price will be deposited in the business account upon creation. Remember, the starting price and amount promised is independent to the amount of shares promised to a person in exchange for investment. This means that a 100$$ investment in a 500$$ business may or may not translate to 20 stocks in the corporation depending on circumstance.<br>\
		<br>\
		Upon creating the business, all new stockholders will automatically be given their stocks. The first thing stockholders should do is assign a CEO of the business and set the basic options stockholders have in the Business Control program.<br>\
		<h3>Business Management</h3><br>\
		The CEO of a business is the primary administrator of the business. Stockholders may elect any person to be the CEO of a business. Stockholders have additional powers to change various options within a business, such as dividends or CEO assigned dividends.<br>\
		<br>\
		Business management is done primarily through the Business Control program.<br>\
		<h3>Material Market</h3><br>\
		The material market is the central market of the economy, and the majority of business will have to make use of it.<br>\
		<br>\
		When looking at the material market, you can see a list of all materials on the market, their highest buy and sell orders, the amount sold in the last hour and the amount sold in the last 24 hours. This allows businesses to see demand and general prices of materials. The price of materials is determined entirely by businesses through this system.<br>\
		<br>\
		By clicking on a material, you can make a buy or sell order at a specific price per unit of that material, as well set the volume of the buy or sell order.<br>\
		<br>\
		You can also quickly buy or sell materials through the material market program by entering their respective tabs. When quick buying a material, you simply select the material and enter the volume of the order. The program will automatically calculate the price based on the current sell orders on the market. The price is subject to change as the market changes.<br>\
		<br>\
		Quick selling works in the same method. You simply put the material you wish to sell on a telepad operated by your business, enter the amount you wish to sell, and the program will automatically give you a final price which is dependent on current orders. The price is subject to change as the market changes.<br>\
		<br>\
		The program also allows you to see the current inventory your business has for sale, and to see or cancel all orders your business has made.<br>\
		<br>"

/obj/item/weapon/paper/guidetonexusseven
	info = "<h2>Chapter 6 - The City Charter</h2><br>\
		<br>\
		<center>\
			<h1>THE SOVEREIGN NEXUS CITY</h1>\
		</center><br>\
		<center>\
			<i>Charter and Amendments</i>\
		</center><br>\
		<br>\
		<br>\
		<b></b>\
		<center>\
			<b><span class='large-text'>PREAMBLE</span></b>\
		</center><br>\
		The People of Nexus, self-determined and endowed by the Artificial Intelligence, have sought to establish a common charter to connect the Nexus people. Inspired by the virtues of the principles set forth in a free, democratically elected government to expand the common welfare, defense, tranquility, and justice. Conscious of their responsibility to the Nexus people and the Artificial Intelligence, this agreement shall link the bond between the electoral process as well as the legal bindings of the Republic. As such, this charter is to be recognized by all people of Nexus regardless of creed or level.<br>\
		<br>\
		<b></b>\
		<center>\
			<b><span class='large-text'>ARTICLE 1. INCORPORATION</span></b>\
		</center><br>\
		<ul>\
			<li style='list-style: none'><br></li>\
			<li>Nexus City is incorporated as a sovereign and independent State. The Government is unitary, republican and democratic.<br>\
			<br></li>\
			<li>The sovereignty and public power of the City is vested in the Government, which shall exercise its authorities pursuant to this Charter and the publicly elected officials.<br>\
			<br></li>\
			<li>The territory of the City shall not be subject to voluntary secession or expansion.<br>\
			<br></li>\
			<li>The Government of the City is divided into the Executive, Legislative and Judicial powers which shall act separately and within their limits.<br></li>\
		</ul><br>\
		<br>\
		<b></b>\
		<center>\
			<b><span class='large-text'>ARTICLE 2. THE COUNCIL</span></b>\
		</center><br>\
		<ul>\
			<li style='list-style: none'><br></li>\
			<li>The legislative power shall be exercised by a Station Council whose members shall be elected from amongst the eligible electors through direct popular vote.<br>\
			<br></li>\
			<li>The Council shall sit as a right a number of times, and in such sessions, as it finds appropriate.<br>\
			<br></li>\
			<li>Any official action of the Council shall require a simple majority of the council, excepting such acts that may require separate votes as according to this Charter.<br></li>\
		</ul><br>\
		<br>\
		<b></b>\
		<center>\
			<b><span class='large-text'>ARTICLE 3. THE LEGISLATIVE POWER</span></b>\
		</center><br>\
		<ul>\
			<li style='list-style: none'><br></li>\
			<li>The legislative power of the City shall extend to all citizens and residents of the City, and to all territory of the City.<br>\
			<br></li>\
			<li>The Council shall exercise its legislative power through civil and criminal law, and through such other categories of legislative action as according to this Charter.<br>\
			<br></li>\
			<li>The legislative power is restricted solely by this Charter, and by the will of the electors of the City.<br>\
			<br></li>\
			<li>No Council may mandate succeeding councils to perform specific acts.<br></li>\
		</ul><br>\
		<br>\
		<b></b>\
		<center>\
			<b><span class='large-text'>ARTICLE 4. THE INDIVIDUAL MANDATES</span></b>\
		</center><br>\
		<ul>\
			<li style='list-style: none'><br></li>\
			<li>Each member of the Council shall be elected with a legislative mandate.<br>\
			<br></li>\
			<li>The mandates, and therefore the five seats of the Council, shall be a Councilor for Justice and Criminal Matters, a Councilor for Budget and Tax Measures, A Councilor for Commerce and Business Relations, a Councilor for Culture and Ethical Oversight and a Councilor for Domestic Affairs.<br>\
			<br></li>\
			<li>Each mandate shall be elected as a separate office.<br>\
			<br></li>\
			<li>Councilors shall be encouraged to present statute and to investigate within their mandate, but shall not be restricted from presenting statute or investigating outside such mandate.<br></li>\
		</ul><br>\
		<br>\
		<b></b>\
		<center>\
			<b><span class='large-text'>ARTICLE 5. THE GOVERNOR AND HIS OFFICERS</span></b>\
		</center><br>\
		<ul>\
			<li style='list-style: none'><br></li>\
			<li>The Governor is the Chief Executive of the City and shall be popularly elected.<br>\
			<br></li>\
			<li>The Governor shall appoint, as according to the rules and regulations set by the Council, such officers of the City that may be established by the Council.<br>\
			<br></li>\
			<li>The Governor shall act as commander-in-chief of the City security forces.<br>\
			<br></li>\
			<li>The Governor shall be the head of government and shall act as the personal symbol of unity of the City.<br>\
			<br></li>\
			<li>All officers of the City that may be established by the Council shall be dismissed by the Governor as according to the rules and regulations set by the Council.<br></li>\
		</ul><br>\
		<br>\
		<b></b>\
		<center>\
			<b><span class='large-text'>ARTICLE 6. THE EXECUTIVE POWER</span></b>\
		</center><br>\
		<ul>\
			<li style='list-style: none'><br></li>\
			<li>The executive power of the City is vested in the Governor and such other officers of the City that may be established by the Council.<br></li>\
		</ul><br>\
		<br>\
		<b></b>\
		<center>\
			<b><span class='large-text'>ARTICLE 7. THE JUDICIARY</span></b>\
		</center><br>\
		<ul>\
			<li style='list-style: none'><br></li>\
			<li>There is a judiciary of the City which shall be composed of such courts and judicial officers that the Council may find necessary to create.<br>\
			<span class='output-end'><span class='write-prompt' title='Players in-game will click this to write on the paper'>write</span></span></li>\
		</ul>"



/datum/book_constructor
	var/title
	var/list/pages = list()
	var/author

/datum/book_constructor/proc/construct()
	var/obj/item/weapon/book/multipage/book = new()
	book.name = title
	book.author = author
	book.title = title
	book.author_real = "premade"

	for(var/x in pages)
		var/obj/item/weapon/paper/P = new x()
		book.pages |= P
	return book
/datum/book_constructor/starterbook
	title = "Guide to Nexus City"
	author = "NEX"
	pages = list(/obj/item/weapon/paper/guidetonexusone, /obj/item/weapon/paper/guidetonexustwo, /obj/item/weapon/paper/guidetonexusthree, /obj/item/weapon/paper/guidetonexusfour, /obj/item/weapon/paper/guidetonexusfive, /obj/item/weapon/paper/guidetonexussix, /obj/item/weapon/paper/guidetonexusseven)

/obj/item/weapon/book/multipage
	var/list/pages = list()
	var/current_page = 0 // If 0 the book is closed
	var/original = 0

/obj/item/weapon/book/multipage/attack_self(var/mob/user as mob)
	if(carved)
		if(store)
			to_chat(user, "<span class='notice'>[store] falls out of [title]!</span>")
			store.loc = get_turf(src.loc)
			store = null
			return
		else
			to_chat(user, "<span class='notice'>The pages of [title] have been cut out!</span>")
			return
	browse_mob(user)
	user.visible_message("[user] opens a book titled \"[src.title]\" and begins reading intently.")
	onclose(user, "book")

/obj/item/weapon/book/multipage/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(carved == 1)
		if(!store)
			if(W.w_class < ITEM_SIZE_NORMAL)
				user.drop_item()
				W.loc = src
				store = W
				to_chat(user, "<span class='notice'>You put [W] in [title].</span>")
				return
			else
				to_chat(user, "<span class='notice'>[W] won't fit in [title].</span>")
				return
		else
			to_chat(user, "<span class='notice'>There's already something in [title]!</span>")
			return
	if(istype(W, /obj/item/weapon/pen))
		to_chat(user, "These pages don't seem to take the ink well. Looks like you can't modify it.")
		return
	else if(istype(W, /obj/item/weapon/material/knife) || isWirecutter(W))
		if(carved)	return
		to_chat(user, "<span class='notice'>You begin to carve out [title].</span>")
		if(do_after(user, 30, src))
			to_chat(user, "<span class='notice'>You carve out the pages from [title]! You didn't want to read it anyway.</span>")
			carved = 1
			return
	else
		..()

/obj/item/weapon/book/multipage/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(user.zone_sel.selecting == BP_EYES)
		if(carved)
			to_chat(user, "The book is carved out and so you cannot show its contents.")
			return
		user.visible_message("<span class='notice'>You open up the book and show it to [M]. </span>", \
			"<span class='notice'> [user] opens up a book and shows it to [M]. </span>")
		browse_mob(M)
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN) //to prevent spam

/obj/item/weapon/book/multipage/proc/browse_mob(mob/living/carbon/M as mob)

	if(current_page)
		if(current_page > pages.len)
			current_page = 0
			return
		var/dat
		if(current_page == pages.len)
			dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'><A href='?src=\ref[src];choice=prev_page'>Previous Page</A></DIV>"
			dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'><A href='?src=\ref[src];choice=close_book'>Close Book</A></DIV>"
			dat+= "<DIV STYLE='float;left; text-align:right; with:33.33333%'><A href='?src=\ref[src];'>Back of book</A></DIV><BR><HR>"
		// middle pages
		else
			dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'><A href='?src=\ref[src];choice=prev_page'>Previous Page</A></DIV>"
			dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'><A href='?src=\ref[src];choice=close_book'>Close Book</A></DIV>"
			dat+= "<DIV STYLE='float:left; text-align:right; width:33.33333%'><A href='?src=\ref[src];choice=next_page'>Next Page</A></DIV><BR><HR>"
		if(istype(pages[current_page], /obj/item/weapon/paper))
			var/obj/item/weapon/paper/P = pages[current_page]
			dat+= "<HTML><HEAD><TITLE>[title]</TITLE></HEAD><BODY>[P.info][P.stamps]</BODY></HTML>"
			M << browse(dat, "window=[title]")
		else if(istype(pages[current_page], /obj/item/weapon/photo))
			var/obj/item/weapon/photo/P = pages[current_page]
			if(P.img)
				M << browse_rsc(P.img, "tmp_photo.png")
			else if(P.render)
				M << browse_rsc(P.render.icon, "tmp_photo.png")
			M << browse(dat + "<html><head><title>[title]</title></head>" \
			+ "<body style='overflow:hidden'>" \
			+ "<div> <center><img src='tmp_photo.png' width = '180'" \
			+ "[P.scribble ? "<div><i>[P.scribble]</i>" : null]"\
			+ "</center></body></html>", "window=[title]")

	else
		M << browse("<center><h1>[title]</h1></center><br><br><i>Authored: [author].</i><br><br>" + "<br><br><a href='?src=\ref[src];choice=next_page'>Open Book</a>", "window=[title]")

/obj/item/weapon/book/multipage/Topic(href, href_list)
	if(..())
		return 1
	if((src in usr.contents) || Adjacent(usr))
		usr.set_machine(src)
		if(href_list["choice"])
			switch(href_list["choice"])
				if("next_page")
					if(current_page < pages.len)
						current_page++
						playsound(src.loc, "pageturn", 50, 1)
				if("prev_page")
					if(current_page > 0)
						current_page--
						playsound(src.loc, "pageturn", 50, 1)
				if("close_book")
					current_page = 0
					playsound(src.loc, "pageturn", 50, 1)

			src.attack_self(usr)
	else
		to_chat(usr, "<span class='notice'>You need to hold it in hands!</span>")


/*
 * Manual Base Object
 */
/obj/item/weapon/book/manual
	icon = 'icons/obj/library.dmi'
	unique = 1   // 0 - Normal book, 1 - Should not be treated as normal book, unable to be copied, unable to be modified
