extends CharacterBody2D


const SPEED = 1000.0
const JUMP_VELOCITY = -400.0
var rots_idx = [1,0.7,0,-0.7,-1]
var rots = [-90,-45,0,45,90]
var score = 0
var temps_restant = 100
var difficulty = 0
var en_vie = true
var prg
var perdu_done = false
var init = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$CursAnim.play("Curs_anim")
	prg = $SpritePrg
	prg.tint_progress = Color(0.1,0.95,0.95,1)


func _physics_process(_delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_horizontale = Input.get_axis("Q", "D")
	var direction_verticale = Input.get_axis("Z", "S")
	var direction = Vector2(direction_horizontale, direction_verticale).normalized()
	if en_vie:
		if direction != Vector2.ZERO:
			tourner_sprite(direction)
			velocity = direction * SPEED
			#tourner_sprite(direction)
		else:
			velocity = Vector2.ZERO
	if !en_vie and !perdu_done:
		velocity = Vector2.ZERO
		get_parent().find_child("AudioControl").find_child("Perdu").play()
		$Ui/EnVie.hide()
		$Ui/GameOver/Recap.text = "Score : " + String.num(score)
		$Ui/GameOver.show()
		$PointLight2D.hide()
		$Timer.stop()
		$CursAnim.stop()
		perdu_done = true
		init = false
	if !en_vie and perdu_done and Input.is_action_just_pressed("ui_accept"):
			get_parent().find_child("ChunkControl").init = true
			$Timer.start()
			$CursAnim.play("Curs_anim")
			$PointLight2D.show()
			position = Vector2(0,0)
			difficulty = 0
			changer_temps_restant(100)
			score = 0
			$Ui/EnVie/Label.text = "Score : " + String.num(score)
			$Ui/GameOver.hide()
			en_vie = true
	
	move_and_slide()


func changer_temps_restant(value):
	temps_restant += value
	if temps_restant > 100: temps_restant = 100
	prg.value = temps_restant
	if prg.value >= 70:
		prg.tint_progress = Color(0.1,0.95,0.95,1)
	if prg.value >= 40 and prg.value < 70:
		prg.tint_progress = Color(0.9,0.8,0.2,1)
	if prg.value >= 0 and prg.value < 40:
		prg.tint_progress = Color(0.9,0.2,0.2,1)
	if prg.value == 0:
		en_vie = false


func ajouter_score(à_ajouter):
	if !init:
		$Timer.start()
		$Ui/EnVie.show()
		init = true
	score += à_ajouter
	$Ui/EnVie/Label.text = "Score : " + String.num(score)
	if à_ajouter == 5: 
		à_ajouter = 20
	if à_ajouter == 1: 
		à_ajouter = 5
	changer_temps_restant(à_ajouter)
	difficulty = int(score / 10)
	if difficulty == 1:
		$Timer.wait_time = 0.7
	if difficulty == 2:
		$Timer.wait_time = 0.6
	if difficulty == 3:
		$Timer.wait_time = 0.5
	if difficulty == 4:
		$Timer.wait_time = 0.4
	if difficulty == 5:
		$Timer.wait_time = 0.3

func tourner_sprite(dir):
	var dot = dir.dot(Vector2.UP)
	var mirror_x = 0
	var mirror_diag = 0
	if dir.x < 0:
		mirror_x = 180
		mirror_diag = 90
	#print(dot)
	if dot == 1 :
		prg.rotation_degrees = -90
	if dot == 0:
		prg.rotation_degrees = 0 + mirror_x
	if dot == -1:
		prg.rotation_degrees = 90
	if is_equal_approx(dot, 0.7071):
		prg.rotation_degrees = -(45 + mirror_diag)
	if is_equal_approx(dot, -0.7071):
		prg.rotation_degrees = 45 + mirror_diag
