extends Control

@export var progress_bar: TextureProgressBar

var hunger: float = 100
var max_hunger: float = 100
var hunger_drain_rate: float = -0.4
var can_hunger_drain: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar.min_value = 0.0
	progress_bar.max_value = max_hunger
	progress_bar.value = hunger


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_hunger(value: float) -> void:
	hunger = clamp(hunger + value, 0.0, max_hunger)

	progress_bar.value = hunger

func _on_timer_timeout() -> void:
	if can_hunger_drain:
		add_hunger(hunger_drain_rate)
