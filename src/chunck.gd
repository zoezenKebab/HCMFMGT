extends Node2D


@export var mur : PackedScene
@export var pièce : PackedScene
@export var ennemi : PackedScene
var joueur
var mur_difficulté = 1
var pièces_difficulté = 1

func _ready():
	var str_pos = String.num(get_parent().calculer_chunk_position(position).x) + "," + String.num(get_parent().calculer_chunk_position(position).y)
	$Label.text = str_pos
	joueur = get_node("/root/main/Player")
	
	
	if joueur.difficulty == 2: 
		pièces_difficulté = 3
	if joueur.difficulty == 3: 
		pièces_difficulté = 3
		mur_difficulté = 2
	if joueur.difficulty == 4: 
		pièces_difficulté = 4
		mur_difficulté = 2
	if joueur.difficulty == 5:
		pièces_difficulté = 4
		mur_difficulté = 2
	if joueur.difficulty == 6:
		pièces_difficulté = 5
		mur_difficulté = 3
	if joueur.difficulty == 7: 
		pièces_difficulté = 5
		mur_difficulté = 3
	if joueur.difficulty >= 8:
		pièces_difficulté = 5
		mur_difficulté = 3
	if joueur.difficulty >= 10:
		pièces_difficulté = 5
		mur_difficulté = 4
	
	if !get_parent().init:
		placement_mur(mur_difficulté)
		placement_pièce(pièces_difficulté)
		placement_ennemi(joueur.difficulty)


func placement_ennemi(diff):
	var encore = 0
	if diff >= 10: encore = 1
	if diff >= 15: encore = 2
	if diff >= 20: encore = 3
	
	var i = -1
	while i < encore:
		var en_ici = randi_range(0,100)
		if en_ici > 100 - diff * 10:
			var n_en = ennemi.instantiate()
			n_en.position = Vector2(randf_range(0,1400), randf_range(0,1400))
			add_child(n_en)
		i += 1


func placement_pièce(difficulté):
	var pièce_ici = randi_range(0,100)
	if pièce_ici < 10:
		var n_obj = pièce.instantiate()
		n_obj.position = Vector2(randf_range(0,1400),randf_range(0,1400))
		n_obj.find_child("Area2D").à_ajouter = 5
		n_obj.self_modulate = Color(0,1,1,0.6)
		n_obj.find_child("FakeLight").modulate = Color(0,1,1,0.8)
		n_obj.find_child("Area2D").son_à_jouer = "SuperPickUp"
		add_child(n_obj)
	
	if pièce_ici < 100 - difficulté * 10:
		var n_obj = pièce.instantiate()
		n_obj.position = Vector2(randf_range(0,1400),randf_range(0,1400))
		n_obj.find_child("Area2D").son_à_jouer = "PickUp"
		add_child(n_obj)

func placement_mur(difficulté):
	for i in difficulté:
		var n_obj = mur.instantiate()
		n_obj.position = Vector2(randf_range(0,1400),randf_range(0,1400))
		n_obj.rotation = randf_range(-360,360)
		n_obj.scale.x = randf_range(0.2, 1)
		n_obj.scale.y = randf_range(1,4)
		add_child(n_obj)
