extends Sprite2D
var base_pos
var sin_offset

# Called when the node enters the scene tree for the first time.
func _ready():
	base_pos = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position.x = base_pos.x + sin(Time.get_ticks_msec()/ 150) * 10
	position.y = base_pos.y + cos(Time.get_ticks_msec()/ 150) * 10
