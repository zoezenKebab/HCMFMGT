extends Node2D

var joueur
var chunks_chargés = []
var chunks_chargés_pos = []
var taille_chunk = 1500
var dernier_chunk
var chunk_actuel
var décalages = [
Vector2i(-1,-1), Vector2i(0,-1), Vector2i(1,-1),
Vector2i(-1,0), Vector2i(0,0), Vector2i(1,0),
Vector2i(-1,1), Vector2i(0,1), Vector2i(1,1)
]
var init = true
@export var chunk : PackedScene

func _ready():
	joueur = get_parent().find_child("Player")
	get_node("/root/main/EnemyTimer").timeout.connect(tick)
	créer_chunks(Vector2i(0,0))

func tick():
	chunk_actuel = calculer_chunk_position(joueur.position)
	if dernier_chunk != chunk_actuel:
		créer_chunks(chunk_actuel)
	dernier_chunk = chunk_actuel


func créer_chunks(position_centre):
	var chunks_en_chargement = []
	for i in range(0,9):
		var i_pos = grandir_vecteur(position_centre) + grandir_vecteur(décalages[i])
		var norm_i_pos = position_centre + décalages[i]
		chunks_en_chargement.append(norm_i_pos)
		
		if chunks_chargés_pos.find(norm_i_pos) == -1:
			var chk = chunk.instantiate()
			chk.position = i_pos
			chunks_chargés_pos.append(norm_i_pos)
			chunks_chargés.append(chk)
			add_child(chk)
	
	var chunks_à_suppr = []
	for élément in chunks_chargés_pos:
		if chunks_en_chargement.find(élément) == -1:
			chunks_à_suppr.append(élément)
	for élément in chunks_à_suppr:
		var idx = chunks_chargés_pos.find(élément)
		chunks_chargés[idx].queue_free()
		chunks_chargés.remove_at(idx)
		chunks_chargés_pos.remove_at(idx)
	
	if init:
		init = false



func calculer_chunk_position(focus):
	var chunk_position = Vector2i.ZERO
	chunk_position.x = int(focus.x / taille_chunk)
	chunk_position.y = int(focus.y / taille_chunk)
	
	if focus.x < 0:
		chunk_position.x -= 1
	if focus.y < 0:
		chunk_position.y -= 1
	
	return chunk_position

func grandir_vecteur(vec) -> Vector2:
	var n_x = vec.x * taille_chunk
	var n_y = vec.y * taille_chunk
	
	return Vector2(n_x,n_y)
