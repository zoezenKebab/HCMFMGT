extends Area2D
var caché = false
var main
var parent
signal ajouter_score
var son_à_jouer = "PickUp"
var à_ajouter = 1

func _ready():
	main = get_node("/root/main")
	parent = get_parent()
	ajouter_score.connect(main.find_child("Player").ajouter_score.bind(à_ajouter))


func _on_body_entered(body):
	if body.name != "Player": return
	ajouter_score.emit()
	parent.hide()
	main.find_child("AudioControl").find_child(son_à_jouer).play()
	
	await get_tree().create_timer(0.01).timeout
	monitoring = false
	parent.queue_free()
