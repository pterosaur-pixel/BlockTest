extends Node3D

const grass_block = preload("res://grassBlock.tscn")

var tree = MyTree.new(32)

var iterator = tree.createIt()
var iterator2 = tree.createIt()
var iterator3 = tree.createIt()
var typeArr = [grass_block, null]
var what_typeArr = ["grass", null]
var raycast
var characterInfo

#ABSOLUTELY NO NEGATIVE COORDINATES EVER ON PAIN OF DEATH!!!!!
#Sorry...
	
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	load_tree()
	
	#change([32, 32, 32], typeArr[0])
	
	change([1, 1, 1], typeArr[0])
	#change([2, 1, 1], typeArr[0])
	#change([3, 1, 1], typeArr[0])

	raycast = get_node("Character/Camera3D/RayCast3D")
	characterInfo = get_node("Character")

	tree.save_tree()
	print("This is where I see what is wrong hopefully")
	tree.print_tree(tree.createIt())
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("save_game"):
		print("saving game...")
		tree.save_tree()
		print("game saved")
	if raycast.get_collider() != null:
		#print("colllided!")
		if Input.is_action_just_pressed("add"):
			print("adding")
			print(raycast.get_collision_point())
			var pos = raycast.get_collision_point()
			var charI = characterInfo.global_position

			var xcf = int(floor(pos.x))
			var ycf = int(floor(pos.y))
			var zcf = int(floor(pos.z))
			
			if abs(pos.x-floor(pos.x)) < 0.0001:
				print("on x side")
				if charI.x > pos.x:
					print("on front")
					change([xcf + 1, ycf + 1, zcf + 1], typeArr[0])
				else:
					print("on back")
					change([xcf, ycf + 1, zcf + 1], typeArr[0])
			#elif is_equal_approx(pos.y, floor(pos.y)):
			elif abs(pos.y-floor(pos.y)) < 0.0001:
				print("on y side")
				
				if charI.y > pos.y:
					print("on front")
					change([xcf + 1, ycf + 1, zcf + 1], typeArr[0])
				else:
					print("on back")
					change([xcf + 1, ycf, zcf + 1], typeArr[0])
			elif abs(pos.z-floor(pos.z)) < 0.0001:
				print("on z side")
				print(charI.z, "***", pos.z)
				if charI.z > pos.z:
					change([xcf + 1, ycf + 1, zcf + 1], typeArr[0])
				else:
					change([xcf + 1, ycf + 1, zcf], typeArr[0])
			else:
				print("This is very important: ", pos)
		if Input.is_action_just_pressed("delete"):
			print("deleting")
			print(raycast.get_collision_point())
			var pos = raycast.get_collision_point()
			var charI = characterInfo.global_position
			
			var xcf = int(floor(pos.x)) + 1
			var ycf = int(floor(pos.y)) + 1
			var zcf = int(floor(pos.z)) + 1
			
			if abs(pos.x-floor(pos.x)) < 0.0001:
				print("on x side")
				if charI.x > pos.x:
					#print("on front")
					change([xcf - 1, ycf, zcf], typeArr[1])
				else:
					#print("on back")
					change([xcf, ycf, zcf], typeArr[1])
			if abs(pos.y-floor(pos.y)) < 0.0001:
				print("on y side")
				
				if charI.y > pos.y:
					#print("on front")
					change([xcf, ycf - 1, zcf], typeArr[1])
				else:
					#print("on back")
					change([xcf, ycf, zcf], typeArr[1])
			if abs(pos.z-floor(pos.z)) < 0.0001:
				print("on z side")
				print(charI.z, "***", pos.z)
				if charI.z > pos.z:
					change([xcf, ycf, zcf - 1], typeArr[1])
				else:
					change([xcf, ycf, zcf], typeArr[1])
		
func load_tree():
		if not FileAccess.file_exists("user://savegame.save"):
			return
		var saveFile = FileAccess.open("user://savegame.save", FileAccess.READ)
		var json_data = saveFile.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_data)
		if not parse_result == OK:
			print("JSON error")
		
		var save_data = json.data
		
		for entry in save_data:
			if not (save_data[entry] == null):
				var coords_to_change = entry.split("*")
				var ctu = Array(coords_to_change)
				var counter = 0
				for i in coords_to_change:
					ctu[counter] = int(i)
					counter += 1
				#print(ctu)
				var nb = null
				if save_data[entry] == "grass":
					nb = grass_block
				change(ctu, nb)
	
class MyNode:
	var leftside = null
	var rightside = null
	var down = null
	var bt = null
	var my_block = null
	var number: float = 2.0
	var ct = null
	var what_block = null
	func _init(num:float , xyz, blocktype, ws, sig, wb):
		#print("Making new object", num, sig, "**")
		self.leftside = null
		self.rightside = null
		self.down = null
		self.bt = blocktype
		self.my_block = null
		self.number = num
		self.ct = xyz
		self.what_block = wb

		if num == 0.5:
			if xyz == 2:
				my_block = blocktype
				
			else:
				down = MyNode.new(ws/2, xyz + 1, blocktype, ws, sig + 1, what_block)

		else:
			leftside = MyNode.new(num/2, xyz, blocktype, ws, sig + 1, what_block)
			rightside = MyNode.new(num/2, xyz, blocktype, ws, sig + 1, what_block)

	func isDone():
		return self.number/2 == 0.5 and self.ct == 2

	func needDown():
		return self.number == 0.5 and self.ct != 2

	func setBlock(new_type, what_type):
		self.bt = new_type
		self.what_block = what_type
		return self.bt
	
		
		
class MyTree:
	var base = null
	var types = [grass_block, null]
	var what_types = ["grass", null]
	func  _init(ws) -> void:
		self.base = MyNode.new(ws/2, 0, null, ws, 1, null)
	
	func print_tree(iterate):
		
		if iterate.isDone():
			#print(iterate.what_block)
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
			#print("why is this running the wrong function?????")
			
			return it.bt
		if it.needDown():
			#print("go down 1")
			it = it.down
		if coords[it.ct] <= it.number:
			#print("go left 1")
			it = it.leftside
			return self.get_block(coords, it)
		else:
			#print("go right 1")
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

	func change_block(coords, it, new_block, nbt):
		#print("changing block")
		if it.isDone():
			#print(new_block)
			return it.setBlock(new_block, nbt)
		if it.needDown():
			#print("go down")
			it = it.down

		if coords[it.ct] <= it.number:
			#print("go left")
			it = it.leftside
			return self.change_block(coords, it, new_block, nbt)
		else:
			#print("go right")
			coords[it.ct] -= it.number
			it = it.rightside
			return self.change_block(coords, it, new_block, nbt)
			
			
	func save_tree():
		var save_dict = {}
		var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
		for i in range(1, 33):
			for j in range(1, 33):
				for k in range(1, 33):
					if get_block([i, j, k], createIt())!= null:
						print(i, j, k)
					save_dict[str(i) + "*" + str(j) + "*" + str(k)] = get_what_block([i, j, k], createIt())
		var json_string = JSON.stringify(save_dict)
		save_file.store_line(json_string)
		
	
		
					
			
func change(coords, nb):
	var iter = tree.createIt()
	print("In the change function: Coords: ", coords, " New Block: ", nb)
	if nb != null:		
		var gb = nb.instantiate()
		add_child(gb)
		gb.position.x = coords[0]
		gb.position.y = coords[1]
		gb.position.z = coords[2]
		tree.change_block(coords, iter, gb, what_typeArr[0])
		
	else:
		var coords2 = [coords[0], coords[1], coords[2]]
		var block_to_del = tree.get_block(coords2, iter)
		#print("block to del: ", block_to_del)
		if block_to_del != null: 
			#print("queueing free")
			tree.change_block(coords, tree.createIt(), typeArr[1], what_typeArr[1])
			block_to_del.queue_free()
		
	# use path "user://savegame.save" to save data
