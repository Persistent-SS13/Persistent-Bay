/datum/computer_file/program/trade
  filename = "trade"
  filedesc = "Trade Management"
  nanomodule_path = /datum/nano_module/program/trade
  program_icon_state = "supply"
  program_menu_icon = "cart"
  extended_desc = "A managment tool for inter-sector trade."
  size = 10
  available_on_ntnet = 1
  requires_ntnet = 1

/datum/nano_module/program/trade
  name = "Trade Management Program"
  var/tmp/screen = 0
  var/tmp/showContents = 0

  var/tmp/list/products = list()
  var/tmp/datum/money_account/linkedAccount

/datum/nano_module/program/trade/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
  var/list/data = host.initial_data()
  data["screen"] = screen
  data["showContents"] = showContents
  data["have_id_slot"] = !!program.computer.card_slot
  data["account"] = linkedAccount ? "[linkedAccount.owner_name]" : 0

  var/list/products = list()
  for(var/i = 1; i <= length(products); i++)
	products.Add(list(list(
	"owner" = products[i]["owner"],
	"name" = products[i]["name"],
	"cost" = products[i]["cost"],
	"id" = i,
	"contents" = showContents ? products[i]["contents"] : 0
	)))
  data["products"] = products

  ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
  if(!ui)
	ui = new(user, src, ui_key, "trade.tmpl", name, 900, 700, state = state)
	ui.set_auto_update(1)
	ui.set_initial_data(data)
	ui.open()
