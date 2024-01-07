extends HBoxContainer

@onready var label = $Label

func _ready():
	update_max_missiles()
	update_missile_label()
	PlayerStats.missiles_changed.connect(update_missile_label)
	PlayerStats.max_missiles_changed.connect(update_max_missiles)

func update_missile_label():
	label.text = str(PlayerStats.missiles)

func update_max_missiles():
	visible = PlayerStats.max_missiles > 0
