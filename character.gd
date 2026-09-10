extends CharacterBody3D

					   
var flying = false;   
var saved = 0;

						   
func _process(_delta: float) -> void:
	
	if Input.is_action_pressed("left"):
		rotation.y += 0.025;
	if Input.is_action_pressed("right"):
		rotation.y -= 0.025;
	if Input.is_action_pressed("up"):
		$Camera3D.rotation.x += 0.025;
		if $Camera3D.rotation.x > PI/2:
			$Camera3D.rotation.x = PI/2

	if Input.is_action_pressed("down"):

		$Camera3D.rotation.x -= 0.025;
		if $Camera3D.rotation.x < -PI/2:
			$Camera3D.rotation.x = -PI/2
		
	
		#if Input.is_action_pressed("shift"):
			#position.y -= 0.35;
		
		
	var direction = Vector3.ZERO;
	if Input.is_action_pressed("w"):
		direction -= global_transform.basis.z
		
	if Input.is_action_pressed("a"):
		direction -= global_transform.basis.x
	if Input.is_action_pressed("s") and not Input.is_action_pressed("save_game"):
		direction = global_transform.basis.z
	if Input.is_action_pressed("d"):
		direction = global_transform.basis.x
		
	velocity = direction * 5;
	velocity.y = 0;
			 
	if !is_on_floor() && !flying:
		velocity.y = saved;
		velocity.y -= 1;
		if velocity.y < -400:
			velocity.y = -400;
		saved = velocity.y;
	if is_on_floor():
		saved = 0;
	
	if Input.is_action_pressed("space"):
		if Input.is_action_just_pressed("fly"):
			flying = !flying;
			
				
	if flying:
		if Input.is_action_pressed("space"):
			velocity.y = 10;
		if Input.is_action_pressed("shift"):
			velocity.y = -10                                                                               ;
	else:
		if Input.is_action_just_pressed("space")&& is_on_floor():
			velocity.y += 15;
			saved += 15; 
	
	#print(saved);	
	move_and_slide()
	
