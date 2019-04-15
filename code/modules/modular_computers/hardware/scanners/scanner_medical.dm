/obj/item/weapon/computer_hardware/scanner/medical
	name = "medical scanner module"
	desc = "A medical scanner module. It can be used to scan patients and display medical information. Also scan DNA samples from organs or full-bodied samples."
	var/datum/dna/stored_dna = null
	var/list/connected_pods = list()

/obj/item/weapon/computer_hardware/scanner/medical/New()
	..()
	ADD_SAVED_VAR(stored_dna)
	ADD_SKIP_EMPTY(stored_dna)

/obj/item/weapon/computer_hardware/scanner/medical/can_use_scanner(mob/user, mob/living/carbon/human/target, proximity = TRUE)
	if(!..())
		return 0
	if(MUTATION_CLUMSY in user.mutations)
		return 0
	if(!istype(target))
		return 0
	if(target.isSynthetic())
		to_chat(user, "<span class='warning'>\The [src] on \the [holder2] is designed for organic humanoid patients only.</span>")
		return 0
	return 1

/obj/item/weapon/computer_hardware/scanner/medical/do_on_afterattack(mob/user, mob/living/carbon/human/target, proximity)
	if(!can_use_scanner(user, target, proximity))
		return
	var/dat = medical_scan_action(target, user, holder2, 1)
	if(dat && driver && driver.using_scanner)
		driver.data_buffer = html2pencode(dat)
		SSnano.update_uis(driver.NM)
	user.visible_message("<span class='notice'>\The [user] runs \the [src] on \the [holder2] over \the [target].</span>")
	to_chat(user, "<hr>[dat]<hr>")
