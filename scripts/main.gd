extends Node2D

# Blue Blood — four screens.
#   DESK    the painted desk is the menu; the objects on it are hot spots
#   MAP     the same map lifted off the desk, pins choose where to go
#   PLACE   empty painted room + a portrait standing in it + dialogue and choices
#   LEDGER  the painted book over a dimmed world, live numbers on the lines
# Nothing here draws a component: every surface is an image from art/.

const GOODS := [
	{"id": "syrup", "name": "COUGH BALM", "price": 0.55, "tags": ["sick"]},
	{"id": "iron", "name": "IRON AMPOULES", "price": 0.75, "tags": ["tired", "sick"]},
	{"id": "salve", "name": "JOINT SALVE", "price": 0.45, "tags": ["work"]},
	{"id": "wash", "name": "BREATH TABS", "price": 0.70, "tags": ["pride"]},
	{"id": "soap", "name": "SCRUB BLOCK", "price": 0.30, "tags": ["clean", "kids"]},
	{"id": "berry", "name": "BERRY CORDIAL", "price": 0.50, "tags": ["kids", "comfort"]},
	{"id": "tea", "name": "TEA", "price": 0.40, "tags": ["comfort", "lonely"]},
	{"id": "salt", "name": "VERMIN BAIT", "price": 0.35, "tags": ["clean"]},
]

const PEOPLE := [
	{"id": "venn", "name": "MARA VENN", "berth": 12, "door": "berth_a", "por": "venn",
	 "cash": 1.10, "trust": 3, "owes": 0.00, "wants": ["sick", "comfort"],
	 "greets": ["You again. The rent went up. My wages did not.",
		"You caught me before the shift. Say it quickly.",
		"The cough is worse. The doctor wants money I have not got.",
		"I am counting, so talk while I count."],
	 "asks": {"sick": "She looks at the bottle longer than she means to.",
		"comfort": "For a moment she is going to say yes to something small.",
		"kids": "She glances at the curtain and does not answer at once.",
		"pride": "She does not like being seen wanting a thing.",
		"work": "Two shifts a day. She knows what an aching body is."},
	 "beat": {"at": 3, "text": "The curtain moves and the coughing starts again. She does not mention it, and she does not move out of the doorway.",
		"opts": [{"label": "ask about the child", "trust": 1, "flag": "knows_child"},
				 {"label": "talk about the price", "trust": -1, "flag": ""}]}},
	{"id": "pratt", "name": "THE PRATTS", "berth": 9, "door": "berth_b", "por": "pratt",
	 "cash": 2.40, "trust": 2, "owes": 0.00, "wants": ["kids", "clean"],
	 "greets": ["Mind the boots. Four of them and none of them dry.",
		"Come in a step, the door sticks in the cold.",
		"The baby has been up since four. So have I.",
		"You are the third man with a case this month."],
	 "asks": {"kids": "She looks at the sleeping bundle, then at the box in your hand.",
		"clean": "She laughs, once, without much in it.",
		"comfort": "There is not much comfort in this room she did not make herself.",
		"pride": "She keeps this room neat. It is all she has to keep."},
	 "beat": {"at": 2, "text": "The jar of coppers is on the shelf with the lid off. She does not put the lid back while you are looking.",
		"opts": [{"label": "pretend not to see it", "trust": 1, "flag": ""},
				 {"label": "offer a discount", "trust": 0, "flag": "discount"}]}},
	{"id": "rok", "name": "ROK", "berth": 31, "door": "berth_c", "por": "rok",
	 "cash": 0.35, "trust": 2, "owes": 2.20, "wants": ["comfort", "lonely"],
	 "greets": ["Leave it open. It is cold in here either way.",
		"You are the only one who knocks.",
		"There is nothing in the pot. That is not a complaint.",
		"The candle is the whole of it tonight."],
	 "asks": {"comfort": "He looks at the tea, then at the one cup on the crate.",
		"sick": "He says he is fine. He says it too quickly.",
		"lonely": "He does not move out of the doorway."},
	 "beat": {"at": 2, "text": "There is a second cup on the crate, upside down, and a ring worn into the wood where it has stood for years.",
		"opts": [{"label": "ask whose cup it was", "trust": 1, "flag": "knows_cup"},
				 {"label": "say nothing", "trust": 1, "flag": ""}]}},
	{"id": "dunn", "name": "DUNN", "berth": 7, "door": "berth_a", "por": "dunn",
	 "cash": 0.80, "trust": 1, "owes": 0.00, "wants": ["work", "pain"],
	 "greets": ["Late shift. Say it quick.",
		"Hand is bad tonight. Make it worth the standing.",
		"You woke the dog. He will get over it.",
		"I have eight minutes."],
	 "asks": {"work": "He flexes the wrapped hand without looking at it.",
		"pain": "He does not answer, which is an answer.",
		"clean": "He looks at his own floor and decides not to care."},
	 "beat": {"at": 3, "text": "The bandage has been changed and it was done badly. He keeps the hand behind the door frame, out of the light.",
		"opts": [{"label": "offer to wrap it properly", "trust": 2, "flag": "wrapped"},
				 {"label": "sell him the salve", "trust": 0, "flag": ""}]}},
	{"id": "halloran", "name": "OLD HALLORAN", "berth": 2, "door": "berth_b", "por": "halloran",
	 "cash": 3.20, "trust": 0, "owes": 0.00, "wants": ["pride", "tired"],
	 "greets": ["I have had a lifetime of men with cases.",
		"You are younger than the last one. He died.",
		"I am not buying. You may still say your piece.",
		"Say it from the step. The mat is clean."],
	 "asks": {"pride": "He looks at the bottle as though it had asked him a personal question.",
		"tired": "He is seventy and he has not sat down all day."},
	 "beat": {"at": 2, "text": "There is an iron tonic bottle on the shelf behind him, empty, put back in its proper place.",
		"opts": [{"label": "ask about the bottle", "trust": 1, "flag": "knows_wife"},
				 {"label": "say nothing", "trust": 0, "flag": ""}]}},
]

const REACT := {
	"venn": {
		"credit": "She counts it out of a tin behind the door. \"Not a word about this.\"",
		"cash": "Coins on the step, counted twice, before she takes the bottle.",
		"refuse": "She looks at the label, then at the curtain behind her. \"I cannot pay for that.\"",
		"debt": "She does not look up. \"Chalk it. And do not look at me like that.\"",
	},
	"pratt": {
		"credit": "She pays from a jar of coppers and asks whether you will be back before the ration runs out.",
		"cash": "The baby shifts on her shoulder while she finds the money.",
		"refuse": "She shakes her head, almost apologetic. \"The children eat first.\"",
		"debt": "\"I know,\" she says, before you ask. \"I know what is chalked.\"",
	},
	"rok": {
		"credit": "He puts the coin in your palm and holds it a moment longer than he needs to.",
		"cash": "He pays in small coin, arranged in a neat line on the crate.",
		"refuse": "He does not take it. \"Keep it for someone with money.\"",
		"debt": "\"It is in the book,\" he says. \"I have not forgotten. I have not got it.\"",
	},
	"dunn": {
		"credit": "He tells you to chalk it and goes back to the sink.",
		"cash": "He drops the coins in the case and shuts the door with his boot.",
		"refuse": "He does not bother to answer.",
		"debt": "\"You will get it Friday,\" he says, and means it no more than last Friday.",
	},
	"halloran": {
		"credit": "He pays from a fold of notes and does not thank you.",
		"cash": "The notes are old and crisp. He counts them twice as a reproach.",
		"refuse": "He lets the pause do the work.",
		"debt": "\"Men with cases always come back,\" he says. \"How tiresome.\"",
	},
}

const PLACES := [
	{"id": "berth_a", "bg": "berth_a", "name": "THE DOORS", "pin": Vector2(0.105, 0.275)},
	{"id": "hub", "bg": "hub", "name": "THE JUNCTION", "pin": Vector2(0.50, 0.945)},
	{"id": "bay", "bg": "bay", "name": "TRADE BAY", "pin": Vector2(0.845, 0.135)},
	{"id": "home", "bg": "home", "name": "YOUR ROOM", "pin": Vector2(0.135, 0.865)},
	{"id": "lift", "bg": "lift", "name": "LIFT MOUTH", "pin": Vector2(0.845, 0.865)},
]

const HOTSPOTS := [
	{"id": "map", "r": Rect2(0.015, 0.030, 0.445, 0.395), "label": "the route"},
	{"id": "book", "r": Rect2(0.470, 0.185, 0.480, 0.455), "label": "the book"},
	{"id": "case", "r": Rect2(0.010, 0.445, 0.295, 0.535), "label": "the case"},
	{"id": "comms", "r": Rect2(0.720, 0.680, 0.150, 0.250), "label": "who is home"},
	{"id": "mug", "r": Rect2(0.800, 0.005, 0.190, 0.215), "label": "end the day"},
	{"id": "coin", "r": Rect2(0.600, 0.660, 0.115, 0.245), "label": "what you have"},
]

var st := {}
var screen := "desk"

var desk_layer: Control
var map_layer: Control
var place_layer: Control
var ledger_layer: Control
var hot_label: Label
var place_bg: TextureRect
var place_por: TextureRect
var cap: Label
var dlg_text: Label
var dlg_opts: GridContainer
var dlg_col: VBoxContainer
var end_layer: Control
var end_title: Label
var end_body: Label
var led_left: Label
var led_right: Label
var toast: Label
var hint_on := true
var at_who := -1
var acts := 0
var sheet_rect := Vector2(1920, 1080)
var door_i := 0

func _ready() -> void:
	var args := OS.get_cmdline_user_args()
	var testing := args.has("--selftest") or args.has("--flowtest") or args.has("--savetest")
	suppress_save = testing
	_reset()
	if not testing:
		_load()
	_build()
	_show_desk()
	for a in args:
		if a == "--map":
			_show_map()
		elif a == "--ledger":
			_show_ledger()
		elif a.begins_with("--care="):
			var n := int(a.substr(7))
			for p in st["people"]:
				var w: Array = p["wants"]
				p["helped"] = []
				for i in mini(n, w.size()):
					p["helped"].append(w[i])
			_goto_place(1)
		elif a == "--ending":
			for p in st["people"]:
				p["helped"] = ["sick", "comfort", "work"]
			_show_end()
		elif a == "--labels":
			_show_desk()
			for h in HOTSPOTS:
				var r: Rect2 = h["r"]
				var lb := _text(desk_layer, 30, Color(1, 0.96, 0.88))
				lb.text = String(h["label"])
				lb.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				lb.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
				lb.position = Vector2(r.position.x * 1920.0, r.position.y * 1080.0)
				lb.size = Vector2(r.size.x * 1920.0, r.size.y * 1080.0)
		elif a == "--hotspots":
			_show_desk()
			_debug_boxes()
		elif a == "--bay":
			_goto_place(2)
		elif a == "--place":
			_goto_place(0)
		elif a.begins_with("--beat="):
			door_i = int(a.substr(7))
			_goto_place(0)
			_show_beat(at_who)
		elif a.begins_with("--who="):
			door_i = int(a.substr(6))
			_goto_place(0)
		elif a == "--pitch":
			_goto_place(0)
			_pitch(at_who)
	if args.has("--playtest"):
		_playtest()
	if args.has("--clicktest"):
		_clicktest()
	if args.has("--savetest"):
		_savetest()
	if args.has("--flowtest"):
		_flowtest()
	if args.has("--selftest"):
		_selftest()
	if args.has("--shot"):
		_shot()



func _playtest() -> void:
	var fails := 0
	var notes := []

	# --- 1. fresh desk, every hot spot responds and lands somewhere sensible
	_wipe()
	_show_desk()
	var expect := {"map": "map", "book": "ledger", "case": "desk", "comms": "desk", "mug": "desk", "coin": "desk"}
	for id in expect:
		_show_desk()
		_desk_action(String(id))
		await get_tree().process_frame
		var want := String(expect[id])
		if screen != want:
			fails += 1
			notes.append("hot spot %s landed on %s, wanted %s" % [id, screen, want])
		print("  desk/%s -> %s" % [id, screen])

	# --- 2. every place loads a plate and says something
	_show_desk()
	for i in PLACES.size():
		_goto_place(i)
		await get_tree().process_frame
		if place_bg.texture == null:
			fails += 1
			notes.append("place %s has no plate" % PLACES[i]["id"])
		if dlg_text.text == "":
			fails += 1
			notes.append("place %s says nothing" % PLACES[i]["id"])
		print("  place %-8s bg=%s line=%s" % [PLACES[i]["id"],
			PLACES[i]["bg"], dlg_text.text.split("
")[0].left(44)])

	# --- 3. one full door in detail: greet, beat, sell, ledger
	_wipe()
	door_i = 0
	_goto_place(0)
	await get_tree().process_frame
	var venn: Dictionary = st["people"][0]
	print("  door greet: ", dlg_text.text.split("
")[0].left(50))
	var before_stock := int(st["stock"]["syrup"])
	var before_delivered := float(st["delivered"])
	_offer(0, "syrup")
	await get_tree().process_frame
	print("  sold: ", dlg_text.text.split("
")[0].left(50))
	if int(st["stock"]["syrup"]) != before_stock - 1:
		fails += 1
		notes.append("stock did not drop on a sale")
	if float(st["delivered"]) <= before_delivered:
		fails += 1
		notes.append("delivered did not rise on a cash sale")
	if int(st["hour"]) != 1:
		fails += 1
		notes.append("the clock did not move on a sale")

	# a wrong good is refused and costs trust
	var t_before := int(st["people"][2]["trust"])
	_offer(2, "wash")
	await get_tree().process_frame
	print("  refused: ", dlg_text.text.split("
")[0].left(50))
	if int(st["people"][2]["trust"]) >= t_before:
		fails += 1
		notes.append("a refusal did not cost trust")

	# giving costs stock and buys trust
	var t2 := int(st["people"][2]["trust"])
	_gift(2)
	await get_tree().process_frame
	if int(st["people"][2]["trust"]) <= t2:
		fails += 1
		notes.append("a gift did not raise trust")

	# --- 4. the depot: draw stock on the account
	_wipe()
	_goto_place(2)
	await get_tree().process_frame
	var tea_before := int(st["stock"]["tea"])
	var adv_before := float(st.get("advanced", 0.0))
	_buy("tea", cost_of({"price": 0.40}))
	await get_tree().process_frame
	if int(st["stock"]["tea"]) != tea_before + 2:
		fails += 1
		notes.append("the depot did not add stock")
	if float(st.get("advanced", 0.0)) <= adv_before:
		fails += 1
		notes.append("the depot did not charge the account")

	# --- 5. ledger numbers agree with the state
	_show_ledger()
	await get_tree().process_frame
	if not led_left.text.contains("%.2f" % float(st["pocket"])):
		fails += 1
		notes.append("the ledger pocket does not match")
	print("  ledger: ", led_left.text.replace("
", " | ").left(70))

	# --- 6. save, wipe, load: the run survives
	var day_before := int(st["day"])
	var pocket_before := float(st["pocket"])
	_save()
	_reset()
	_load()
	if int(st["day"]) != day_before or abs(float(st["pocket"]) - pocket_before) > 0.001:
		fails += 1
		notes.append("the save did not restore")

	# --- 7. four weeks to the closing screen
	_wipe()
	for i in 40:
		if int(st["week"]) >= 5:
			break
		_end_day()
		await get_tree().process_frame
	if not end_layer.visible:
		fails += 1
		notes.append("the closing screen never appeared")
	print("  closing screen visible: ", end_layer.visible, "  week ", st["week"])


	# --- 8. beats fire once, and their options move trust
	_wipe()
	for wi in st["people"].size():
		var person: Dictionary = st["people"][wi]
		var beat_at := int(person["beat"]["at"])
		var fired := 0
		for visit in 4:
			door_i = wi
			_goto_place(0)
			await get_tree().process_frame
			if dlg_text.text.contains(String(person["beat"]["text"]).left(30)):
				fired += 1
				var before_trust := int(st["people"][wi]["trust"])
				_beat_take(wi, person["beat"]["opts"][0])
				await get_tree().process_frame
				print("  beat %-8s visit %d, trust %d -> %d" % [person["id"], visit + 1,
					before_trust, int(st["people"][wi]["trust"])])
		if fired != 1:
			fails += 1
			notes.append("%s played its scene %d times" % [person["id"], fired])

	# --- 9. asking for money moves coin or costs trust, never crashes
	_wipe()
	st["people"][2]["owes"] = 1.50
	st["people"][2]["cash"] = 1.50
	var owed_before := float(st["people"][2]["owes"])
	_collect(2)
	await get_tree().process_frame
	print("  collect: owed %.2f -> %.2f, pocket %.2f" % [owed_before,
		float(st["people"][2]["owes"]), float(st["pocket"])])
	if float(st["people"][2]["owes"]) > owed_before:
		fails += 1
		notes.append("collecting made the debt bigger")

	# --- 10. four hours close a day, and the day closes the door
	_wipe()
	_goto_place(0)
	await get_tree().process_frame
	for h in 4:
		_offer(0, "syrup")
		await get_tree().process_frame
	if int(st["hour"]) != 0 or int(st["day"]) != 2:
		fails += 1
		notes.append("four calls did not close the day")
	print("  after four calls: day %d hour %d place %s" % [st["day"], st["hour"], screen])

	# --- 11. the closing screen appears once, not every week after
	_wipe()
	for i in 60:
		if end_layer.visible:
			break
		_end_day()
		await get_tree().process_frame
	var seen := 0
	for i in 3:
		_show_desk()
		await get_tree().process_frame
		_end_day()
		await get_tree().process_frame
		if end_layer.visible:
			seen += 1
	if seen > 0:
		fails += 1
		notes.append("the closing screen came back %d more times" % seen)

	print("=== PLAYTEST %s ===" % ("PASS" if fails == 0 else "FAIL"))
	for n in notes:
		print("   ! ", n)
	get_tree().quit()

func _clicktest() -> void:
	print("=== click test: does the desk respond? ===")
	var fails := 0
	for h in HOTSPOTS:
		var r: Rect2 = h["r"]
		var at := Vector2((r.position.x + r.size.x * 0.5) * 1920.0, (r.position.y + r.size.y * 0.5) * 1080.0)
		_show_desk()
		await get_tree().process_frame
		var before := acts
		for pressed in [true, false]:
			var ev := InputEventMouseButton.new()
			ev.button_index = MOUSE_BUTTON_LEFT
			ev.pressed = pressed
			ev.position = at
			ev.global_position = at
			get_viewport().push_input(ev)
			await get_tree().process_frame
		await get_tree().process_frame
		var fired := acts > before
		print("  %-6s at %4d,%4d  fired=%s" % [h["id"], int(at.x), int(at.y), str(fired)])
		if not fired:
			fails += 1
	_show_desk()
	print("=== %s (%d of %d did nothing) ===" % ["PASS" if fails == 0 else "FAIL", fails, HOTSPOTS.size()])
	get_tree().quit()

func _savetest() -> void:
	print("=== save round trip ===")
	_wipe()
	st["day"] = 4
	st["pocket"] = 12.75
	st["delivered"] = 3.40
	st["stock"]["tea"] = 2
	st["people"][2]["owes"] = 1.85
	st["people"][2]["trust"] = 4
	st["people"][2]["visits"] = 3
	st["people"][2]["beat_done"] = true
	st["people"][2]["flags"] = ["knows_cup"]
	_save()
	var before := "%d/%.2f/%.2f/%d/%s" % [st["day"], st["pocket"], st["delivered"],
		int(st["stock"]["tea"]), str(st["people"][2]["flags"])]
	_reset()
	var ok := _load()
	var after := "%d/%.2f/%.2f/%d/%s" % [st["day"], st["pocket"], st["delivered"],
		int(st["stock"]["tea"]), str(st["people"][2]["flags"])]
	print("  before ", before)
	print("  after  ", after, "  loaded=", ok)
	print("  owes %.2f  trust %d  visits %d  beat %s" % [float(st["people"][2]["owes"]),
		int(st["people"][2]["trust"]), int(st["people"][2]["visits"]), str(st["people"][2]["beat_done"])])
	var pass_: bool = bool(ok) and before == after and abs(float(st["people"][2]["owes"]) - 1.85) < 0.001
	print("=== %s ===" % ("PASS" if pass_ else "FAIL"))
	_wipe()
	get_tree().quit()

func _flowtest() -> void:
	var fails := 0
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	print("=== two weeks of knocking ===")
	for day in range(14):
		for h in range(4):
			var who := rng.randi_range(0, st["people"].size() - 1)
			at_who = who
			var wanted: Array = st["people"][who]["wants"]
			var pick := ""
			for g in GOODS:
				if int(st["stock"][g["id"]]) <= 0:
					continue
				for t in g["tags"]:
					if wanted.has(t):
						pick = g["id"]
			if pick == "":
				for g in GOODS:
					if int(st["stock"][g["id"]]) > 0:
						pick = g["id"]
			if pick == "":
				pick = "tea"
			if float(st["people"][who]["owes"]) > 0.4 and rng.randf() < 0.5:
				_collect(who)
			else:
				_offer(who, pick)
			for gid in st["stock"]:
				if int(st["stock"][gid]) < 0:
					print("  FAIL negative stock ", gid)
					fails += 1
			if float(st["delivered"]) < 0.0:
				print("  FAIL negative delivered")
				fails += 1
			if float(st["pocket"]) < -0.01:
				print("  FAIL pocket negative ", st["pocket"])
				fails += 1
		print("  day %d done: delivered %.2f pocket %.2f owed %.2f" % [
			st["day"], st["delivered"], st["pocket"], _total_owed()])
	var owed := _total_owed()
	var chalked := 0.0
	for p in st["people"]:
		chalked += float(p["owes"])
	var cond := []
	for p in st["people"]:
		cond.append("%s %s" % [String(p["name"]).split(" ")[0], _condition(p)])
	print("  care avg %.2f  |  %s" % [_avg_care(), ", ".join(cond)])
	print("  owed %.2f  chalked %.2f  week %d quota %.0f" % [owed, chalked, st["week"], st["quota"]])
	if abs(owed - chalked) > 0.001:
		print("  FAIL owed mismatch"); fails += 1
	if int(st["week"]) < 2:
		print("  FAIL weeks did not advance"); fails += 1
	print("=== %s (%d failures) ===" % ["PASS" if fails == 0 else "FAIL", fails])
	get_tree().quit()

func _total_owed() -> float:
	var t := 0.0
	for p in st["people"]:
		t += float(p["owes"])
	return t

func _selftest() -> void:
	print("--- three pitches ---")
	for who in [0, 1, 2]:
		at_who = who
		_offer(who, "syrup")
		print("  ", dlg_text.text)
	print("  delivered=%.2f pocket=%.2f hour=%d" % [st["delivered"], st["pocket"], st["hour"]])
	print("--- right goods for the right room ---")
	at_who = 1
	_offer(1, "soap")
	print("  ", dlg_text.text)
	at_who = 3
	_offer(3, "salve")
	print("  ", dlg_text.text)
	_draw_ledger()
	print("--- ledger ---")
	print(led_left.text.replace("
", " | "))
	print(led_right.text.replace("
", " | "))
	print("--- days ---")
	for i in 8:
		_end_day()
	print("  day=%d hour=%d week=%d quota=%.0f" % [st["day"], st["hour"], st["week"], st["quota"]])
	get_tree().quit()

func _reset() -> void:
	var stock := {}
	for g in GOODS:
		stock[g["id"]] = 6
	st = {"day": 1, "hour": 0, "week": 1, "quota": 6.0, "delivered": 0.0,
		"pocket": 6.0, "advanced": 0.0, "stock": stock, "people": PEOPLE.duplicate(true), "ledger": []}
	for p in st["people"]:
		p["visits"] = 0
		p["beat_done"] = false
		p["flags"] = []
		p["helped"] = []

func _build() -> void:
	desk_layer = _layer(1)
	place_layer = _layer(3)
	map_layer = _layer(4)
	ledger_layer = _layer(5)
	var ui := _layer(6)

	_art(desk_layer, "res://art/ui/desk.png")
	hot_label = _text(desk_layer, 30, Color(1, 0.96, 0.88))
	hot_label.modulate.a = 0.0

	cap = _text(ui, 28, Color(1, 0.95, 0.88))
	cap.position = Vector2(48, 30)

	toast = _text(ui, 24, Color(1, 0.93, 0.78))
	toast.position = Vector2(48, 992)
	toast.size = Vector2(1800, 60)
	toast.autowrap_mode = TextServer.AUTOWRAP_WORD
	toast.modulate.a = 0.0

	_build_desk_hotspots()
	_build_map()
	_build_place()
	_build_ledger()
	_build_end()

func _layer(n: int) -> Control:
	var cl := CanvasLayer.new()
	cl.layer = n
	add_child(cl)
	var c := Control.new()
	c.set_anchors_preset(Control.PRESET_FULL_RECT)
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cl.add_child(c)
	return c

func _art(parent: Control, path: String) -> TextureRect:
	var t := TextureRect.new()
	t.texture = load(path)
	t.ignore_texture_size = true
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	t.set_anchors_preset(Control.PRESET_FULL_RECT)
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(t)
	return t

func _text(parent_: Control, size: int, col: Color) -> Label:
	var l := Label.new()
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", col)
	l.add_theme_color_override("font_outline_color", Color(0.04, 0.03, 0.03, 0.92))
	l.add_theme_constant_override("outline_size", 6)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent_.add_child(l)
	return l


# ------------------------------------------------------------ save
const SAVE_PATH := "user://blueblood_save.json"

var suppress_save := false

func _save() -> void:
	if suppress_save:
		return
	var people := []
	for p in st["people"]:
		people.append({"id": p["id"], "cash": p["cash"], "trust": p["trust"], "owes": p["owes"],
			"visits": p["visits"], "beat_done": p["beat_done"], "flags": p["flags"]})
	var data := {"version": 1, "day": st["day"], "hour": st["hour"], "week": st["week"],
		"quota": st["quota"], "delivered": st["delivered"], "pocket": st["pocket"],
		"stock": st["stock"], "people": people, "ledger": st["ledger"],
		"advanced": st.get("advanced", 0.0), "ended": st.get("ended", false)}
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(data, "	"))
		f.close()

func _has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func _load() -> bool:
	if not _has_save():
		return false
	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not f:
		return false
	var txt := f.get_as_text()
	f.close()
	var data = JSON.parse_string(txt)
	if typeof(data) != TYPE_DICTIONARY:
		return false
	_reset()
	st["day"] = int(data.get("day", 1))
	st["hour"] = int(data.get("hour", 0))
	st["week"] = int(data.get("week", 1))
	st["quota"] = float(data.get("quota", 6.0))
	st["delivered"] = float(data.get("delivered", 0.0))
	st["pocket"] = float(data.get("pocket", 6.0))
	st["advanced"] = float(data.get("advanced", 0.0))
	var stock: Dictionary = data.get("stock", {})
	for gid in stock:
		if st["stock"].has(gid):
			st["stock"][gid] = int(stock[gid])
	for saved in data.get("people", []):
		for p in st["people"]:
			if String(p["id"]) == String(saved.get("id", "")):
				p["cash"] = float(saved.get("cash", p["cash"]))
				p["trust"] = int(saved.get("trust", p["trust"]))
				p["owes"] = float(saved.get("owes", p["owes"]))
				p["visits"] = int(saved.get("visits", 0))
				p["beat_done"] = bool(saved.get("beat_done", false))
				p["flags"] = saved.get("flags", [])
	var led = data.get("ledger", [])
	st["ledger"] = led if typeof(led) == TYPE_ARRAY else []
	return true

func _wipe() -> void:
	if _has_save():
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))
	_reset()
	_save()
	_show_desk()
	_say("a clean book. day one, and the same six credits.")

# ------------------------------------------------------------ desk
func _build_desk_hotspots() -> void:
	for h in HOTSPOTS:
		var r: Rect2 = h["r"]
		var b := Button.new()
		b.flat = true
		b.position = Vector2(r.position.x * 1920.0, r.position.y * 1080.0)
		b.size = Vector2(r.size.x * 1920.0, r.size.y * 1080.0)
		var sid := String(h["id"])
		var lab := String(h["label"])
		b.mouse_entered.connect(func() -> void: _label_on(lab, b))
		b.mouse_exited.connect(func() -> void: hot_label.modulate.a = 0.0)
		b.pressed.connect(func() -> void:
			hint_on = false
			_desk_action(sid))
		desk_layer.add_child(b)

func _debug_boxes() -> void:
	for h in HOTSPOTS:
		var r: Rect2 = h["r"]
		var box := ColorRect.new()
		box.color = Color(1, 0.1, 0.1, 0.28)
		box.position = Vector2(r.position.x * 1920.0, r.position.y * 1080.0)
		box.size = Vector2(r.size.x * 1920.0, r.size.y * 1080.0)
		box.mouse_filter = Control.MOUSE_FILTER_IGNORE
		desk_layer.add_child(box)
		var tag := _text(desk_layer, 22, Color(1, 0.95, 0.4))
		tag.text = String(h["id"])
		tag.position = box.position + Vector2(8, 4)

func _label_on(lab: String, box: Control) -> void:
	hot_label.text = lab
	hot_label.size = Vector2(box.size.x, box.size.y)
	hot_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hot_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hot_label.position = box.position
	hot_label.modulate.a = 1.0

func _desk_action(id: String) -> void:
	acts += 1
	match id:
		"map":
			_show_map()
		"book":
			_show_ledger()
		"case":
			_show_case()
		"comms":
			_show_comms()
		"mug":
			_end_day()
		"coin":
			_say("pocket %.2f, and %.2f still short this week." % [st["pocket"], max(0.0, float(st["quota"]) - float(st["delivered"]))])

func _show_desk() -> void:
	screen = "desk"
	cap.visible = true
	if end_layer:
		end_layer.visible = false
	desk_layer.visible = true
	map_layer.visible = false
	place_layer.visible = false
	ledger_layer.visible = false
	cap.text = "DAY %d   ·   HOUR %d/4   ·   WEEK %d   ·   %.2f / %.0f%s" % [
		st["day"], st["hour"], st["week"], st["delivered"], st["quota"],
		"
(pick something up off the desk)" if hint_on else ""]

func _show_case() -> void:
	var lines := []
	for g in GOODS:
		lines.append("%s %d" % [g["name"], int(st["stock"][g["id"]])])
	_say("  ·  ".join(lines))

func _show_comms() -> void:
	var lines := []
	for p in st["people"]:
		var tail := ""
		if float(p["owes"]) > 0.0:
			tail = " owes %.2f" % p["owes"]
		lines.append("%s, berth %d — %s%s" % [p["name"], p["berth"], _condition(p), tail])
	_say("  |  ".join(lines))

func _say(t: String) -> void:
	toast.text = t
	var tw := create_tween()
	tw.tween_property(toast, "modulate:a", 1.0, 0.12)
	tw.tween_interval(3.6)
	tw.tween_property(toast, "modulate:a", 0.0, 0.6)

# ------------------------------------------------------------ map
func _build_map() -> void:
	var dark := ColorRect.new()
	dark.color = Color(0.03, 0.04, 0.05, 0.9)
	dark.set_anchors_preset(Control.PRESET_FULL_RECT)
	map_layer.add_child(dark)

	# the opened map is its own painting; if it is not there yet, fall back to the desk crop
	var sheet := TextureRect.new()
	sheet.texture = load("res://art/ui/map_full.png")
	sheet.ignore_texture_size = true
	sheet.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	sheet.position = Vector2(0, 0)
	sheet.size = Vector2(1920, 1080)
	map_layer.add_child(sheet)
	sheet_rect = Vector2(1920, 1080)

	for i in PLACES.size():
		var pin := Button.new()
		pin.flat = true
		pin.text = String(PLACES[i]["name"])
		pin.add_theme_font_size_override("font_size", 21)
		pin.add_theme_color_override("font_color", Color(0.13, 0.09, 0.06, 0.92))
		pin.add_theme_color_override("font_hover_color", Color(0.62, 0.20, 0.08))
		pin.add_theme_color_override("font_hover_pressed_color", Color(0.62, 0.20, 0.08))
		pin.add_theme_color_override("font_outline_color", Color(0.98, 0.94, 0.85, 0.95))
		pin.add_theme_constant_override("outline_size", 6)
		var pp: Vector2 = PLACES[i]["pin"]
		pin.position = Vector2(sheet_rect.x * pp.x - 110.0, sheet_rect.y * pp.y - 20.0)
		pin.size = Vector2(220, 46)
		var idx := i
		pin.pressed.connect(func() -> void: _goto_place(idx))
		map_layer.add_child(pin)

	var back := Button.new()
	back.flat = true
	back.text = "back to the desk"
	back.add_theme_font_size_override("font_size", 22)
	back.add_theme_color_override("font_color", Color(1, 0.9, 0.75, 0.75))
	back.position = Vector2(250, 986)
	back.pressed.connect(_show_desk)
	map_layer.add_child(back)


func _build_end() -> void:
	end_layer = _layer(7)
	end_layer.visible = false

	var dark := ColorRect.new()
	dark.color = Color(0.02, 0.03, 0.04, 0.94)
	dark.set_anchors_preset(Control.PRESET_FULL_RECT)
	dark.mouse_filter = Control.MOUSE_FILTER_IGNORE
	end_layer.add_child(dark)

	end_title = _text(end_layer, 38, Color(1, 0.94, 0.84))
	end_title.position = Vector2(180, 150)
	end_title.size = Vector2(1500, 60)

	end_body = _text(end_layer, 26, Color(0.92, 0.9, 0.84))
	end_body.position = Vector2(180, 236)
	end_body.size = Vector2(1280, 640)
	end_body.autowrap_mode = TextServer.AUTOWRAP_WORD

	var again := Button.new()
	again.flat = true
	again.text = "begin the route again"
	again.add_theme_font_size_override("font_size", 24)
	again.add_theme_color_override("font_color", Color(1, 0.84, 0.5))
	again.position = Vector2(180, 972)
	again.pressed.connect(_wipe)
	end_layer.add_child(again)

func _show_end() -> void:
	end_title.text = "THE ROUTE, AFTER FOUR WEEKS"
	var lines := []
	for p in st["people"]:
		lines.append("%s, berth %d — %s" % [p["name"], p["berth"], _condition(p)])
	lines.append("")
	var looked := 0
	for p in st["people"]:
		if _care(p) >= 3:
			looked += 1
	if looked >= 4:
		lines.append("Almost every door on this ring is warmer than it was. They do not thank you, and you would not know what to say if they did.")
	elif looked >= 2:
		lines.append("Two or three rooms are better than they were. The rest still count their coins twice. It is not nothing.")
	elif looked >= 1:
		lines.append("One room is warmer. You will take that.")
	else:
		lines.append("The book is full of names and the rooms are the same. You sold things. That is all you did.")
	lines.append("")
	lines.append("The company has posted a new quota to your desk. It does not know any of this.")
	end_body.text = "
".join(lines)
	desk_layer.visible = false
	map_layer.visible = false
	place_layer.visible = false
	ledger_layer.visible = false
	end_layer.visible = true
	cap.visible = false
	toast.modulate.a = 0.0

func _show_map() -> void:
	screen = "map"
	cap.visible = true
	desk_layer.visible = false
	map_layer.visible = true
	cap.text = "WHERE TO   ·   DAY %d   ·   %.2f / %.0f" % [st["day"], st["delivered"], st["quota"]]

func _goto_place(i: int) -> void:
	cap.visible = true
	var pl: Dictionary = PLACES[i]
	at_who = _who_here(String(pl["id"]))
	var bg_id := String(pl["bg"])
	if String(pl["id"]) == "hub" and _avg_care() >= 1.5:
		bg_id = "hub_late"
	if at_who >= 0:
		bg_id = String(st["people"][at_who]["door"])
	place_bg.texture = load("res://art/bg/%s.png" % bg_id)
	map_layer.visible = false
	ledger_layer.visible = false
	desk_layer.visible = false
	place_layer.visible = true
	screen = "place"
	at_who = _who_here(String(pl["id"]))
	if at_who >= 0:
		var who_p: Dictionary = st["people"][at_who]
		cap.text = "BERTH %d   ·   %s" % [who_p["berth"], who_p["name"]]
	else:
		cap.text = String(pl["name"])
	if at_who >= 0:
		var p: Dictionary = st["people"][at_who]
		place_por.texture = load("res://art/por/%s.png" % p["por"])
		place_por.visible = true
		p["visits"] = int(p["visits"]) + 1
		var beat: Dictionary = p["beat"]
		if int(p["visits"]) >= int(beat["at"]) and not bool(p["beat_done"]):
			_show_beat(at_who)
		else:
			_speak(_greet_line(p), p)
	else:
		place_por.visible = false
		match String(pl["id"]):
			"bay":
				_bay_menu()
			"home":
				_home_menu()
			"hub":
				if _avg_care() >= 1.5:
					_say_at("Two passages, one going down to the lift. Somebody has put a blanket on the bench and a row of plants in cut-down tins. The board is full.")
				else:
					_say_at("Two passages, one going down to the lift. Somebody chalked a tally by the hatch and rubbed half of it out.")
			"lift":
				_say_at("The cage is down. It smells of oil and somebody's dinner.")
			_:
				_say_at("")

func _who_here(place: String) -> int:
	if place != "berth_a":
		return -1
	door_i = wrapi(door_i, 0, st["people"].size())
	return door_i

func _next_door() -> void:
	door_i = wrapi(door_i + 1, 0, st["people"].size())
	_goto_place(0)

# ------------------------------------------------------------ place
func _build_place() -> void:
	place_bg = _art(place_layer, "res://art/bg/hub.png")

	place_por = TextureRect.new()
	place_por.ignore_texture_size = true
	place_por.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var por_h := 1075.0
	place_por.size = Vector2(por_h * 2.0 / 3.0, por_h)
	place_por.position = Vector2(1120, 1080.0 - por_h + 18.0)
	place_layer.add_child(place_por)

	var scrim := TextureRect.new()
	scrim.texture = load("res://art/ui/scrim_bottom.png")
	scrim.ignore_texture_size = true
	scrim.stretch_mode = TextureRect.STRETCH_SCALE
	scrim.set_anchors_preset(Control.PRESET_FULL_RECT)
	scrim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	place_layer.add_child(scrim)

	# text and choices share one column, so long lines push the choices down
	dlg_col = VBoxContainer.new()
	dlg_col.position = Vector2(96, 560)
	dlg_col.size = Vector2(1000, 496)
	dlg_col.alignment = BoxContainer.ALIGNMENT_END
	dlg_col.add_theme_constant_override("separation", 14)
	place_layer.add_child(dlg_col)

	dlg_text = _text(dlg_col, 30, Color(1, 0.96, 0.9))
	dlg_text.autowrap_mode = TextServer.AUTOWRAP_WORD
	dlg_text.custom_minimum_size = Vector2(1000, 0)
	dlg_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	dlg_opts = GridContainer.new()
	dlg_opts.columns = 1
	dlg_opts.custom_minimum_size = Vector2(1000, 0)
	dlg_opts.add_theme_constant_override("h_separation", 24)
	dlg_opts.add_theme_constant_override("v_separation", 2)
	dlg_col.add_child(dlg_opts)

	var back := Button.new()
	back.flat = true
	back.text = "back to the desk"
	back.add_theme_font_size_override("font_size", 22)
	back.add_theme_color_override("font_color", Color(1, 0.9, 0.75, 0.7))
	back.position = Vector2(1650, 30)
	back.pressed.connect(_show_desk)
	place_layer.add_child(back)

func _opt(text: String, cb: Callable) -> Button:
	var b := Button.new()
	b.flat = true
	b.text = text
	b.alignment = HORIZONTAL_ALIGNMENT_LEFT
	b.custom_minimum_size = Vector2(462, 40)
	b.add_theme_font_size_override("font_size", 23)
	b.add_theme_color_override("font_color", Color(0.88, 0.87, 0.82))
	b.add_theme_color_override("font_hover_color", Color(1, 0.82, 0.5))
	b.add_theme_color_override("font_focus_color", Color(1, 0.82, 0.5))
	b.add_theme_color_override("font_outline_color", Color(0.03, 0.03, 0.03, 0.9))
	b.add_theme_constant_override("outline_size", 5)
	b.pressed.connect(cb)
	return b

func _layout_opts(cols: int) -> void:
	dlg_opts.columns = cols
	dlg_opts.add_theme_constant_override("h_separation", 26 if cols == 1 else 18)

func _clear_opts() -> void:
	_layout_opts(1)
	for c in dlg_opts.get_children():
		c.queue_free()

func _greet_line(p: Dictionary) -> String:
	var gs: Array = p["greets"]
	if gs.is_empty():
		return ""
	return String(gs[(int(p["visits"]) - 1) % gs.size()])

func _show_beat(who: int) -> void:
	var p: Dictionary = st["people"][who]
	var beat: Dictionary = p["beat"]
	p["beat_done"] = true
	dlg_text.text = "%s
— %s" % [String(beat["text"]), p["name"]]
	_clear_opts()
	for o in beat["opts"]:
		var opt: Dictionary = o
		dlg_opts.add_child(_opt(String(opt["label"]), func() -> void: _beat_take(who, opt)))

func _beat_take(who: int, opt: Dictionary) -> void:
	var p: Dictionary = st["people"][who]
	p["trust"] = clampi(int(p["trust"]) + int(opt["trust"]), 0, 5)
	var flag := String(opt["flag"])
	if flag != "":
		var flags: Array = p["flags"]
		if not flags.has(flag):
			flags.append(flag)
	_save()
	_speak(_greet_line(p), p)

func _speak(line: String, p: Dictionary) -> void:
	dlg_text.text = "%s\n— %s" % [line, String(p["name"])]
	_clear_opts()
	var who := at_who
	dlg_opts.add_child(_opt("show what is in the case", func() -> void: _pitch(who)))
	dlg_opts.add_child(_opt("ask about what is chalked in the book", func() -> void: _ask_debt(who)))
	dlg_opts.add_child(_opt("leave it for today", func() -> void: _show_desk()))
	dlg_opts.add_child(_opt("knock at the next door", func() -> void: _next_door()))

func _say_at(line: String) -> void:
	dlg_text.text = line
	_clear_opts()
	dlg_opts.add_child(_opt("back to the desk", func() -> void: _show_desk()))

func _ask_line(p: Dictionary, tag: String) -> String:
	var table: Dictionary = p.get("asks", {})
	return String(table.get(tag, ""))

func _voice(p: Dictionary, key: String) -> String:
	var table: Dictionary = REACT.get(String(p["id"]), {})
	return String(table.get(key, ""))

func _ask_debt(who: int) -> void:
	var p: Dictionary = st["people"][who]
	if float(p["owes"]) <= 0.0:
		dlg_text.text = "Nothing on the slate. %s watches to see whether that is good news." % p["name"]
	else:
		dlg_text.text = "%s   ·   %.2f

%s" % [p["name"], p["owes"], _voice(p, "debt")]
	_clear_opts()
	if float(p["owes"]) > 0.0:
		dlg_opts.add_child(_opt("ask for what is owed", func() -> void: _collect(who)))
	dlg_opts.add_child(_opt("show the case anyway", func() -> void: _pitch(who)))
	dlg_opts.add_child(_opt("leave", func() -> void: _show_desk()))

func _collect(who: int) -> void:
	_save()
	var p: Dictionary = st["people"][who]
	var owed := float(p["owes"])
	var cash := float(p["cash"])
	var paid: float = min(owed, cash)
	var odds := 0.18 + 0.12 * float(p["trust"])
	var got: float = paid if randf() < odds else 0.0
	if got > 0.0:
		p["owes"] = owed - got
		p["cash"] = cash - got
		st["pocket"] = float(st["pocket"]) + got
		st["delivered"] = float(st["delivered"]) + got
		dlg_text.text = "%.2f, counted out slowly and without a word about it." % got
		if float(p["owes"]) < 0.01:
			p["owes"] = 0.0
	else:
		p["trust"] = max(0, int(p["trust"]) - 1)
		dlg_text.text = _voice(p, "debt")
	_tick()
	_clear_opts()
	dlg_opts.add_child(_opt("go on", func() -> void: _show_desk()))
	dlg_opts.add_child(_opt("knock at the next door", func() -> void: _next_door()))

func _pitch(who: int) -> void:
	var p: Dictionary = st["people"][who]
	dlg_text.text = "%s waits.\nThe case holds what you carried out this morning." % p["name"]
	_clear_opts()
	_layout_opts(2)
	for g in GOODS:
		if int(st["stock"][g["id"]]) <= 0:
			continue
		var gid := String(g["id"])
		dlg_opts.add_child(_opt("%s   %.2f" % [g["name"], g["price"]], func() -> void: _offer(who, gid)))
	dlg_opts.add_child(_opt("give it away, ask nothing", func() -> void: _gift(who)))

func _offer(who: int, gid: String) -> void:
	_save()
	var p: Dictionary = st["people"][who]
	var g := {}
	for x in GOODS:
		if x["id"] == gid:
			g = x
	var fit := 0
	var hit := ""
	for t in g["tags"]:
		if p["wants"].has(t):
			fit += 3
			if hit == "":
				hit = String(t)
	var price: float = float(g["price"])
	var cash: float = float(p["cash"])
	var line := ""
	if fit >= 3 and cash >= price:
		_note_care(p, hit)
		st["stock"][gid] = int(st["stock"][gid]) - 1
		st["delivered"] = float(st["delivered"]) + price
		st["pocket"] = float(st["pocket"]) + price
		p["cash"] = cash - price
		p["trust"] = min(5, int(p["trust"]) + 1)
		line = "%s

%s

The case is lighter by one." % [_ask_line(p, hit), _voice(p, "cash")]
	elif fit >= 3:
		_note_care(p, hit)
		st["stock"][gid] = int(st["stock"][gid]) - 1
		p["owes"] = float(p["owes"]) + price
		st["ledger"].append({"who": p["name"], "amount": price})
		line = "%s

%s

%.2f chalked in the book." % [_ask_line(p, hit), _voice(p, "credit"), price]
	elif fit > 0:
		p["trust"] = max(0, int(p["trust"]) - 1)
		line = _voice(p, "refuse")
	else:
		p["trust"] = max(0, int(p["trust"]) - 1)
		line = "%s

That was the wrong thing to bring out." % _voice(p, "refuse")
	_tick()
	_after(line, p)

func _note_care(p: Dictionary, tag: String) -> void:
	var helped: Array = p["helped"]
	if tag != "" and not helped.has(tag):
		helped.append(tag)

func _care(p: Dictionary) -> int:
	return (p.get("helped", []) as Array).size()

func _condition(p: Dictionary) -> String:
	var c := _care(p)
	if c <= 0:
		return "cold"
	elif c == 1:
		return "barely holding"
	elif c == 2:
		return "steadier"
	return "looked after"

func _avg_care() -> float:
	var t := 0.0
	for p in st["people"]:
		t += float(_care(p))
	return t / max(1.0, float(st["people"].size()))

func _gift(who: int) -> void:
	_save()
	var p: Dictionary = st["people"][who]
	_note_care(p, "gift")
	p["trust"] = min(5, int(p["trust"]) + 2)
	for gid in st["stock"]:
		if int(st["stock"][gid]) > 0:
			st["stock"][gid] = int(st["stock"][gid]) - 1
			break
	_tick()
	_after("You hand it over and say nothing about money. %s looks at the floor." % p["name"], p)

func _after(line: String, p: Dictionary) -> void:
	dlg_text.text = line
	_clear_opts()
	dlg_opts.add_child(_opt("go on", func() -> void: _show_desk()))
	dlg_opts.add_child(_opt("stay a moment", func() -> void: _speak(String(p["greet"]), p)))
	dlg_opts.add_child(_opt("knock at the next door", func() -> void: _next_door()))

func _bay_menu() -> void:
	place_por.texture = load("res://art/por/keeper.png")
	place_por.visible = true
	cap.text = "DEPOT   ·   RING 3   ·   WALKER & SONS"
	dlg_text.text = "The clerk does not look up from the clipboard.
\"Drawn against your account, same as everyone. Sign here.\"
— THE DEPOT CLERK"
	_clear_opts()
	_layout_opts(2)
	for g in GOODS:
		var gid := String(g["id"])
		var cost := cost_of(g)
		dlg_opts.add_child(_opt("%s  x2   %.2f" % [g["name"], cost], func() -> void: _buy(gid, cost)))
	dlg_opts.add_child(_opt("nothing today", func() -> void: _show_desk()))

func cost_of(g: Dictionary) -> float:
	return snappedf(float(g["price"]) * 0.4, 0.01)

func _buy(gid: String, cost: float) -> void:
	if float(st.get("advanced", 0.0)) + cost <= float(st["quota"]) * 1.5:
		st["advanced"] = float(st.get("advanced", 0.0)) + cost
		st["stock"][gid] = int(st["stock"][gid]) + 2
		_tick()
		_save()
		_refresh_after_buy("%s into the case. Charged to your account, not paid for." % _good_name(gid))
	else:
		_refresh_after_buy("Your account is at its limit. The clerk says nothing, which is the company's way of saying it.")

func _good_name(gid: String) -> String:
	for g in GOODS:
		if String(g["id"]) == gid:
			return String(g["name"])
	return gid

func _refresh_after_buy(line: String) -> void:
	dlg_text.text = line + "
— THE DEPOT CLERK"
	_clear_opts()
	for g in GOODS:
		var gid := String(g["id"])
		var cost := cost_of(g)
		dlg_opts.add_child(_opt("%s  x2   %.2f" % [g["name"], cost], func() -> void: _buy(gid, cost)))
	dlg_opts.add_child(_opt("done, back to the desk", func() -> void: _show_desk()))

func _home_menu() -> void:
	dlg_text.text = "Your own room. The book is on the desk and the case is by the door.\nDay %d, hour %d of four." % [st["day"], st["hour"]]
	_clear_opts()
	dlg_opts.add_child(_opt("open the book", func() -> void: _show_ledger()))
	dlg_opts.add_child(_opt("sleep, end the day", func() -> void: _end_day()))

# ------------------------------------------------------------ ledger
func _build_ledger() -> void:
	var dark := ColorRect.new()
	dark.color = Color(0.03, 0.04, 0.05, 0.86)
	dark.set_anchors_preset(Control.PRESET_FULL_RECT)
	ledger_layer.add_child(dark)

	var book := TextureRect.new()
	book.texture = load("res://art/ui/book.png")
	book.ignore_texture_size = true
	book.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	book.position = Vector2(200, 54)
	book.size = Vector2(1520, 972)
	ledger_layer.add_child(book)

	led_left = _ink(ledger_layer, Vector2(372, 186), Vector2(500, 780))
	led_right = _ink(ledger_layer, Vector2(1032, 186), Vector2(410, 780))

	var wipe := Button.new()
	wipe.flat = true
	wipe.text = "burn the book and start again"
	wipe.add_theme_font_size_override("font_size", 19)
	wipe.add_theme_color_override("font_color", Color(0.62, 0.28, 0.22, 0.75))
	wipe.position = Vector2(1180, 1000)
	wipe.pressed.connect(_wipe)
	ledger_layer.add_child(wipe)

	var back := Button.new()
	back.flat = true
	back.text = "close the book"
	back.add_theme_font_size_override("font_size", 22)
	back.add_theme_color_override("font_color", Color(1, 0.92, 0.8, 0.8))
	back.position = Vector2(240, 1000)
	back.pressed.connect(_show_desk)
	ledger_layer.add_child(back)

func _ink(parent_: Control, pos: Vector2, size: Vector2) -> Label:
	var l := Label.new()
	l.position = pos
	l.size = size
	l.add_theme_font_override("font", load("res://art/fonts/Inkfree.ttf"))
	l.add_theme_font_size_override("font_size", 30)
	l.add_theme_color_override("font_color", Color(0.17, 0.11, 0.08))
	parent_.add_child(l)
	return l

func _show_ledger() -> void:
	screen = "ledger"
	cap.visible = false
	_draw_ledger()
	desk_layer.visible = false
	map_layer.visible = false
	place_layer.visible = false
	ledger_layer.visible = true

func _draw_ledger() -> void:
	led_left.text = "WEEK %d     DAY %d     HOUR %d\n\nQUOTA      %.0f\nDELIVERED  %.2f\nSHORT      %.2f\n\nPOCKET     %.2f
ADVANCED   %.2f" % [
		st["week"], st["day"], st["hour"], st["quota"], st["delivered"],
		max(0.0, float(st["quota"]) - float(st["delivered"])), st["pocket"],
		float(st.get("advanced", 0.0))]
	var r := "ACCOUNTS\n\n"
	var any := false
	for p in st["people"]:
		if float(p["owes"]) > 0.0:
			r += "%-9s %5.2f\n" % [String(p["name"]).split(" ")[0], p["owes"]]
			any = true
	if not any:
		r += "nothing owed.\nnot yet."
	led_right.text = r

# ------------------------------------------------------------ time
func _tick() -> void:
	st["hour"] = int(st["hour"]) + 1
	if int(st["hour"]) >= 4:
		_end_day()

func _end_day() -> void:
	_save()
	st["day"] = int(st["day"]) + 1
	st["hour"] = 0
	for p in st["people"]:
		p["cash"] = float(p["cash"]) + randf_range(0.30, 0.95) + 0.12 * float(_care(p))
	if int(st["day"]) % 7 == 1:
		st["week"] = int(st["week"]) + 1
		st["quota"] = 6.0 + 2.0 * (int(st["week"]) - 1)
		st["delivered"] = 0.0
		st["advanced"] = 0.0
		if int(st["week"]) >= 5 and not bool(st.get("ended", false)):
			st["ended"] = true
			_save()
			_show_end()
			return
	var week_over: bool = int(st["hour"]) == 0 and int(st["day"]) % 7 == 1
	_show_desk()
	if week_over:
		var made := float(st["delivered"]) >= float(st["quota"])
		_say("the week closes. %s" % ("the number is made. the company says nothing, which is praise." if made else "short. it goes in a letter, and the letter goes in a file."))
	else:
		_say("day %d. %.2f of %.0f. the station does not care either way." % [st["day"], st["delivered"], st["quota"]])

func _unhandled_input(e: InputEvent) -> void:
	if e is InputEventKey and e.pressed and not e.echo and e.keycode == KEY_ESCAPE:
		_show_desk()

func _shot() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	var img := get_viewport().get_texture().get_image()
	var dest := "user://shot.png"
	if not OS.has_feature("template"):
		dest = ProjectSettings.globalize_path("res://shot.png")
	img.save_png(dest)
	print("shot ", screen, " -> ", ProjectSettings.globalize_path(dest))
	get_tree().quit()
