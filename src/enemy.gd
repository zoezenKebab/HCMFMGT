extends Node2D

var position_tween : Tween
var joueur
var distance_detection = 800
var distance_à_joueur = Vector2.ZERO
var peux_foncer = true

func _ready():
	joueur = get_node("/root/main/Player")
	get_node("/root/main/EnemyTimer").timeout.connect(tick)
	$AnimSpr.play("sprite_animation")


func tick():
	distance_à_joueur = joueur.position - global_position
	if  distance_à_joueur.length() <= distance_detection and peux_foncer and joueur.en_vie:
		if distance_à_joueur.normalized().dot(Vector2.RIGHT) < 0:
			$Sprite2D.scale.x = -0.4
		else:
			$Sprite2D.scale.x = 0.4
		attaque_fonce(joueur.position, 5)



func attaque_fonce(pos_cible, durée):
	metal()
	position_tween = create_tween()
	position_tween.set_ease(Tween.EASE_OUT)
	position_tween.set_trans(Tween.TRANS_EXPO)
	
	position_tween.tween_property(self, "global_position", pos_cible, durée)
	peux_foncer = false
	$Audio.play()
	await get_tree().create_timer(1).timeout
	peux_foncer = true
	

func metal():
	$MetalGear.show()
	await get_tree().create_timer(0.5).timeout
	$MetalGear.hide()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		joueur.en_vie = false
		joueur.get_parent().find_child("AudioControl").find_child("Perdu").play()
