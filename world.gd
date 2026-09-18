extends Node3D

const grass_block = preload("res://grassBlock.tscn")
const brick_temp = preload("res://brick.tscn")
const lantern = preload("res://lantern.tscn")
const water_block = preload("res://water_block.tscn")
const door = preload("res://static_body_3d.tscn")

var tree = MyTree.new(32)

var iterator = tree.createIt()
var iterator2 = tree.createIt()
var iterator3 = tree.createIt()
var typeArr = [grass_block, null, brick_temp, lantern, water_block, door]
var what_typeArr = ["grass", null, "brick", "lantern", "water", "door"]
var raycast
var characterInfo
var inv_Arr = ["Grass", "Bricks", "Lantern", "Water", "Door"]
var index_in_inv = 0
var inv_label

#ABSOLUTELY NO NEGATIVE COORDINATES EVER ON PAIN OF DEATH!!!!!
#Sorry...
	
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	load_tree()
	
	#change([32, 32, 32], typeArr[0])
	
	#Some issue - when I have the change in here it won't delete? I think the block is instantiated twice!!!!!!
	
	change([1, 1, 1], typeArr[0], "grass")
	#change([2, 1, 1], typeArr[0])
	#change([3, 1, 1], typeArr[0])

	raycast = get_node("Character/Camera3D/RayCast3D")
	characterInfo = get_node("Character")
	
	inv_label = get_node("Character/Camera3D/Active Mat")
	
	tree.save_tree()
	#tree.print_tree(tree.createIt())


	
func _process(_delta: float) -> void:
	
		
	if Input.is_action_just_pressed("nextInv"):
		index_in_inv += 1
		if index_in_inv >= inv_Arr.size():
			index_in_inv = 0
		inv_label.text = inv_Arr[index_in_inv]
		
	if Input.is_action_just_pressed("save_game"):
		print("saving game...")
		tree.save_tree()
		print("game saved")
	var rcCol = raycast.get_collider()
	if rcCol != null:
		
		if Input.is_action_just_pressed("add"):
			if rcCol.get_collision_layer_value(2):
				var ind = 0
				if index_in_inv > 0:
					#print("ind", ind)
					ind += index_in_inv + 1
					#print("ind", ind)
				#print("adding")
				#print(raycast.get_collision_point())
				var pos = raycast.get_collision_point()
				var charI = characterInfo.global_position

				var xcf = int(floor(pos.x))
				var ycf = int(floor(pos.y))
				var zcf = int(floor(pos.z))
				
				if abs(pos.x-floor(pos.x)) < 0.001:
					var x_rot = 0.0
					if charI.x > pos.x:
						if what_typeArr[ind] == "brick":
							x_rot = PI/2
						change([xcf + 1, ycf + 1, zcf + 1], typeArr[ind], what_typeArr[ind], 0.0, 0.0, x_rot)
					else:
						if what_typeArr[ind] == "brick":
							x_rot = -PI/2
						change([xcf, ycf + 1, zcf + 1], typeArr[ind], what_typeArr[ind], 0.0, 0.0, x_rot)
				#elif is_equal_approx(pos.y, floor(pos.y)):
				elif abs(pos.y-floor(pos.y)) < 0.001:
					var rot = 0.0
					if characterInfo.rotation.y > PI/4 and characterInfo.rotation.y < 3*PI/4 and what_typeArr[ind] == "door":
						rot = PI/2
					if characterInfo.rotation.y < -PI/4 and characterInfo.rotation.y > -3*PI/4 and what_typeArr[ind] == "door":
						rot = PI/2
		
					#if characterInfo.rotation.y < PI/4 and characterInfo.rotation.y > -PI/4:
						#print("facing z")
					#if characterInfo.rotation.y > 3*PI/4 and characterInfo.rotation.y < 5*PI/4:
						#print("facing z")
					if charI.y > pos.y:
						
						change([xcf + 1, ycf + 1, zcf + 1], typeArr[ind], what_typeArr[ind], rot)
					else:
						change([xcf + 1, ycf, zcf + 1], typeArr[ind], what_typeArr[ind], rot)
				elif abs(pos.z-floor(pos.z)) < 0.001:
					var rot_z = 0.0
					if charI.z > pos.z:
						if what_typeArr[ind] == "brick":
							rot_z = PI/2
						change([xcf + 1, ycf + 1, zcf + 1], typeArr[ind], what_typeArr[ind], 0.0, rot_z, 0.0)
					else:
						if what_typeArr[ind] == "brick":
							rot_z = -PI/2
						change([xcf + 1, ycf + 1, zcf], typeArr[ind], what_typeArr[ind], 0.0, rot_z, 0.0)
				#else:
					#print("This is very important: ", pos)
					
			if rcCol.get_collision_layer_value(3):
				print("opening door")
				var pos = raycast.get_collision_point()
				var charI = characterInfo.global_position
#
				var xcf = int(floor(pos.x))
				var ycf = int(floor(pos.y))
				var zcf = int(floor(pos.z))
				
				var my_door

				
				#my_door = tree.get_block([xcf + 1, ycf + 1, zcf + 1], tree.createIt())

				if abs(pos.x-floor(pos.x)) < 0.001:
					print("x")
					if charI.x > pos.x:
						my_door = tree.get_block([xcf, ycf + 1, zcf + 1], tree.createIt())
					else:
						my_door = tree.get_block([xcf + 1, ycf + 1, zcf + 1], tree.createIt())
				#elif is_equal_approx(pos.y, floor(pos.y)):
				if abs(pos.y-floor(pos.y)) < 0.001:
					print("y")
					if charI.y > pos.y:
						my_door = tree.get_block([xcf + 1, ycf - 1, zcf + 1], tree.createIt())
					else:
						my_door = tree.get_block([xcf + 1, ycf, zcf + 1], tree.createIt())
				elif abs(pos.z-floor(pos.z)) < 0.001:
					print("z")
					if charI.z > pos.z:
						my_door = tree.get_block([xcf + 1, ycf + 1, zcf], tree.createIt())
					else:
						my_door = tree.get_block([xcf + 1, ycf + 1, zcf+1], tree.createIt())
				#else:
					#print("This is very important: ", pos)
				print("opening/closing", my_door)
				if my_door != null:
					if my_door.get_node("MeshInstance3D").rotation.y < 0.001 and my_door.get_node("MeshInstance3D").rotation.y > -0.0001:
						my_door.get_node("MeshInstance3D").rotation.y += PI/2
						#my_door.get_node("MeshInstance3D").global_position.x -= 0.4
						my_door.set_collision_layer_value(1, false)
						if characterInfo.rotation.y > PI/4 and characterInfo.rotation.y < 3*PI/4:
							print("not on x")
							my_door.get_node("MeshInstance3D").global_position.z -= 0.4
						elif characterInfo.rotation.y < -PI/4 and characterInfo.rotation.y > -3*PI/4:
							print("not on x")
							my_door.get_node("MeshInstance3D").global_position.z -= 0.4
						else:
							print("On x")
							my_door.get_node("MeshInstance3D").global_position.x -= 0.4
						print("Going down")
					else:
						my_door.set_collision_layer_value(1, true)
						my_door.get_node("MeshInstance3D").rotation.y -= PI/2
						#my_door.get_node("MeshInstance3D").global_position.x += 0.4
						print("Going up")
						if characterInfo.rotation.y > PI/4 and characterInfo.rotation.y < 3*PI/4:
							my_door.get_node("MeshInstance3D").global_position.z += 0.4
						elif characterInfo.rotation.y < -PI/4 and characterInfo.rotation.y > -3*PI/4:
							my_door.get_node("MeshInstance3D").global_position.z += 0.4
						else:
							my_door.get_node("MeshInstance3D").global_position.x += 0.4
					
		if Input.is_action_just_pressed("delete") and not Input.is_action_just_pressed("add"):
			print("deleting")
			#print(raycast.get_collision_point())
			var pos = raycast.get_collision_point()
			var charI = characterInfo.global_position
			
			var xcf = int(floor(pos.x)) + 1
			var ycf = int(floor(pos.y)) + 1
			var zcf = int(floor(pos.z)) + 1
			
			if abs(pos.x-floor(pos.x)) < 0.001:
				if charI.x > pos.x:
					change([xcf - 1, ycf, zcf], typeArr[1], what_typeArr[1])
				else:
					change([xcf, ycf, zcf], typeArr[1], what_typeArr[1])
			if abs(pos.y-floor(pos.y)) < 0.001:

				
				if charI.y > pos.y:
					change([xcf, ycf - 1, zcf], typeArr[1], what_typeArr[1])
				else:
					change([xcf, ycf, zcf], typeArr[1], what_typeArr[1])
			if abs(pos.z-floor(pos.z)) < 0.001:
				if charI.z > pos.z:
					change([xcf, ycf, zcf - 1], typeArr[1], what_typeArr[1])
				else:
					change([xcf, ycf, zcf], typeArr[1], what_typeArr[1])
		
func load_tree():
		if not FileAccess.file_exists("user://savegame.save"):
			generate_base_terrain()
			return
			
		var saveFile = FileAccess.open("user://savegame.save", FileAccess.READ)
		var json_data = saveFile.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_data)
		if not parse_result == OK:
			print("JSON error")
			generate_base_terrain()
		
		var save_data = json.data
		
		for entry in save_data:
			var sde = save_data[entry].split("*")
			if not (sde[0] == "null"):
				var coords_to_change = entry.split("*")
				var ctu = Array(coords_to_change)
				var counter = 0
				for i in coords_to_change:
					ctu[counter] = int(i)
					counter += 1
				var nb = null
				var type = null
				#var s_d_e_t = save_data[entry]
				#var saved_rot = save_data[entry][1]
				if sde[0] == "grass":
					nb = grass_block
					type = "grass"
				if sde[0]== "brick":
					nb = brick_temp
					type = "brick"
				if sde[0] == "lantern":
					nb = lantern
					type = "lantern"
				if sde[0] == "water":
					nb = water_block
					type = "water"
				if sde[0] == "door":
					nb = door
					type = "door"
				#float(saved_rot)
				change(ctu, nb, type, float(sde[1]), float(sde[2]), float(sde[3]))
	
class MyNode:
	var leftside = null
	var rightside = null
	var down = null
	var bt = null
	var my_block = null
	var number: float = 2.0
	var ct = null
	var what_block = null
	var rotation = 0.0
	var rotationx = 0.0
	var rotationz = 0.0
	func _init(num:float , xyz, blocktype, ws, sig, wb):
		self.leftside = null
		self.rightside = null
		self.down = null
		self.bt = blocktype
		self.my_block = null
		self.number = num
		self.ct = xyz
		self.what_block = wb

		if num == 0.25:
			if xyz == 2:
				my_block = blocktype
				
			else:
				down = MyNode.new(ws/2, xyz + 1, blocktype, ws, sig + 1, what_block)

		else:
			leftside = MyNode.new(num/2, xyz, blocktype, ws, sig + 1, what_block)
			rightside = MyNode.new(num/2, xyz, blocktype, ws, sig + 1, what_block)

	func isDone():
		return self.number/2 == 0.25 and self.ct == 2

	func needDown():
		return self.number == 0.25 and self.ct != 2

	func setBlock(new_type, what_type, rot = 0.0, rotx = 0.0, rotz = 0.0):
		self.bt = new_type
		self.what_block = what_type
		self.rotation = rot
		self.rotationx = rotx
		self.rotationz = rotz
		return self.bt
	
		
		
class MyTree:
	var base = null
	var types = [grass_block, null]
	var what_types = ["grass", null]
	func  _init(ws) -> void:
		self.base = MyNode.new(ws/2, 0, null, ws, 1, null)
	
	func print_tree(iterate):
		#If this function is correct then the problem is with the add function
		if iterate.isDone():
			
			if iterate.bt != null:
				print(iterate.bt)
			return
		if iterate.needDown():
			iterate = iterate.down
		print_tree(iterate.leftside)
		
		print_tree(iterate.rightside)
		return
		
	func getBase():
		return self.base

	func createIt():
		var it = self.base
		return it
	
	func get_block(coords, it):
		if it.isDone():
			return it.bt

		if it.needDown():
			it = it.down

		if coords[it.ct] <= it.number:
			it = it.leftside
			return self.get_block(coords, it)

		else:
			coords[it.ct] -= it.number
			it = it.rightside
			return self.get_block(coords, it)

	func get_what_block(coordinates, it):
		if it.isDone():
			#if it.what_block != null:
				#print("These are where we are: ")
				#print(coordinates)
				#print(it.what_block)
			return it.what_block
		if it.needDown():
			it = it.down
			
		if coordinates[it.ct] <= it.number:
			it = it.leftside
			return self.get_what_block(coordinates, it)
			
		else:
			coordinates[it.ct] -= it.number
			it = it.rightside
			return self.get_what_block(coordinates, it)

	func change_block(coords, it, new_block, nbt, rot = 0.0, rotx = 0.0, rotz = 0.0):
		if it.isDone():
			return it.setBlock(new_block, nbt, rot, rotx, rotz)
			
		if it.needDown():
			it = it.down

		if coords[it.ct] <= it.number:
			it = it.leftside
			return self.change_block(coords, it, new_block, nbt, rot, rotx, rotz)
			
		else:
			coords[it.ct] -= it.number
			it = it.rightside
			return self.change_block(coords, it, new_block, nbt, rot, rotx, rotz)
			
	func get_rotation(coords, it, x_y_z = 0):
		if it.isDone():
			if x_y_z == 0:
				return it.rotation
			if x_y_z == 1:
				return it.rotationx
			if x_y_z == 2:
				return it.rotationz
			
		if it.needDown():
			it = it.down

		if coords[it.ct] <= it.number:
			it = it.leftside
			return self.get_rotation(coords, it, x_y_z)
			
		else:
			coords[it.ct] -= it.number
			it = it.rightside
			return self.get_rotation(coords, it, x_y_z)

		
	
	func save_tree():
		var save_dict = {}
		var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
		for i in range(1, 33):
			for j in range(1, 33):
				for k in range(1, 33):
					#if get_block([i, j, k], createIt())!= null:
					#	print(get_what_block([i, j, k], createIt()))
					#get_rotation([i, j, k], createIt())
					var wbh = get_what_block([i, j, k], createIt())
					var rotation = get_rotation([i, j, k], createIt())
					var rotation2 = get_rotation([i, j, k], createIt(), 1)
					var rotation3 = get_rotation([i, j, k], createIt(), 2)
					if wbh == null:
						wbh = "null"
					save_dict[str(i) + "*" + str(j) + "*" + str(k)] = wbh + "*" + str(rotation) + "*" + str(rotation2) + "*" + str(rotation3)
		var json_string = JSON.stringify(save_dict)
		save_file.store_line(json_string)
		
			
func change(coords, nb, wb, rot=0.0, rotx = 0.0, rotz = 0.0):
	var iter = tree.createIt()
	#print("In the change function: Coords: ", coords, " New Block: ", nb)
	if nb != null:
		var coordsGWB = [coords[0], coords[1], coords[2]]
		
		if null == tree.get_what_block(coordsGWB, tree.createIt()):			
			var gb = nb.instantiate()
			add_child(gb)
			gb.position.x = coords[0] - 0.5
			gb.position.y = coords[1] - 0.5
			gb.position.z = coords[2] -0.5
			gb.rotation.y = rot
			gb.rotation.x = rotx
			gb.rotation.z = rotz
			
			tree.change_block(coords, iter, gb, wb, rot, rotx, rotz)


		
	else:
		var coords2 = [coords[0], coords[1], coords[2]]
		var block_to_del = tree.get_block(coords2, iter)
		#print("block to del: ", block_to_del)
		if block_to_del != null: 
			#print("queueing free")
			tree.change_block(coords, tree.createIt(), typeArr[1], what_typeArr[1])
			block_to_del.queue_free()




func generate_base_terrain():
	for i in range(1, 33):
		for j in range(1, 33):
			var change_arr = [i, 1, j]
			change(change_arr, typeArr[0], "grass")
