/obj/item/weapon/computer_hardware/scanner/medical
	name = "medical scanner module"
	desc = "A medical scanner module. It can be used to scan patients and display medical information."
	var/datum/dna/stored_dna = null
	var/list/connected_pods = list()

/obj/item/weapon/computer_hardware/scanner/medical/do_on_afterattack(mob/user, atom/target, proximity)
	if(!can_use_scanner(user, target, proximity))
		return

	var/dat = medical_scan_action(target, user, holder2, 1)

	if(dat && driver && driver.using_scanner)
		driver.data_buffer = html2pencode(dat)
		SSnano.update_uis(driver.NM)

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

/obj/item/weapon/computer_hardware/scanner/medical/do_on_attackby(mob/user, obj/item/target)
	if(istype(target, /obj/item/organ))
		var/obj/item/organ/O = target
		stored_dna = O.dna
		return 1
	if(istype(target, /obj/item/weapon/reagent_containers/syringe))
		var/obj/item/weapon/reagent_containers/syringe/S = target
		if(!S.reagents)
			return
		if(S.reagents.total_volume == 0)
			return
		var/datum/reagent/blood/cnt = S.reagents.get_master_reagent()
		if(!istype(cnt) || !islist(cnt.get_data()))
			return
		var/list/data = cnt.get_data()
		stored_dna = data["blood_DNA"]
		return 1
	return ..()