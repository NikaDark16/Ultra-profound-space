extends KinematicBody2D

var MAX_SPEED = 500
var ACCELERATION = 2000
var motion = Vector2()
	

func _physics_process(delta):
	var axis = get_input_axis()
	if axis == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)
	motion = move_and_slide(motion)
	
	print(rad2deg(rotation))
	if (rotation >= -180 and rotation <= -179.98):
		print("fuck")

func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))

	if axis != Vector2.ZERO and rotation != Vector2.ZERO.angle_to_point(axis.normalized()):
		print(rad2deg(rotation), " ", rad2deg(Vector2.ZERO.angle_to_point(axis.normalized())))
		$Tween.interpolate_property(self, "rotation", rotation, Vector2.ZERO.angle_to_point(axis.normalized()), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		if not $Tween.is_active():
			#rotation = Vector2.ZERO.angle_to_point(axis.normalized()) + 3*PI/2
			$Tween.start()

	return axis.normalized()

func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO

func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)
