/datum/computer_file/program/crew_manifest
	filename = "cmanifest"
	filedesc = "Crew Manifest"
	extended_desc = "View the workers on your station/ship and their jobs."
	program_icon_state = "generic"
	size = 2
	available_on_ntnet = 0
	undeletable = 1
	unsendable = 1

	nanomodule_path = /datum/nano_module/program/crew_manifest

/datum/nano_module/program/crew_manifest
	name = "Crew Manifest Program"
	available_to_ai = TRUE

/datum/nano_module/program/crew_manifest/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	data_core.get_manifest_list()
	var/list/data = list()
	data = host.initial_data()
	data["manifest"] = PDA_Manifest
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "manifest.tmpl", "Crew Manifest", 500, 600, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()