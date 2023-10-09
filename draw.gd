@tool
extends Node2D
class_name PhysicScene

@export var ResetScene = false :
	set(val) : 
		genarate_paticle()
		cal_target_delta()	
@export var OpenLog = false
@export var targetFps:int = 120

@export var radius = 10
@export var color = Color(1.0,0,0)
@export var mass = 1
@export var smooth_radius = 50

@export var random_pos = true
@export var spawn_paticle:Vector2i
@export var box:Rect2 

@export var gravity:float = 100 :
	set(val) : 
		PhysicProp.gravity = val
		gravity = val 
	get :
		return gravity

var paticles:Array[PhyPaticle]
var target_delta
var current_delta:float = 0
func _ready():
	PhysicProp.gravity = gravity
	cal_target_delta()
	paticles = []
	genarate_paticle()

func patical_arr()->Array[Vector2]:
	var arr:Array[Vector2] = []
	for p in paticles :
		arr.push_back(p.pos)
	return arr

func _process(delta):
	material.set_shader_parameter("smooth_radius",smooth_radius)
	material.set_shader_parameter("points",patical_arr())
	material.set_shader_parameter("mass",mass)
	current_delta += delta
	if current_delta < target_delta : return
	current_delta = 0
	for pa in paticles :
		pa.update(delta)
		out_off_box(pa)
	queue_redraw()

func genarate_paticle():
	paticles = []
	for y in range(spawn_paticle.y):
		for x in range(spawn_paticle.x ):
			
			if random_pos :
				var randx = randf_range(box.position.x,box.end.x)
				var randy = randf_range(box.position.y,box.end.y)
				var pos = Vector2(randx,randy)
				paticles.push_back(PhyPaticle.new(pos))
			else :	
				var pos = Vector2(
					x*radius*2 + box.position.x + radius,
					y*radius*2 + box.position.y + radius)
				paticles.push_back(PhyPaticle.new(pos))

func cal_target_delta():
	target_delta = 1.0 / targetFps
	if OpenLog : print(target_delta)

func out_off_box(paticle:PhyPaticle):
	
	if paticle.pos.y + radius > box.end.y :
		paticle.pos.y = box.end.y - radius
		paticle.velocity.y *= -1 * PhysicProp.colldamping
	if paticle.pos.y - radius < box.position.y :
		paticle.pos.y = box.position.y + radius
		paticle.velocity.y *= -1 * PhysicProp.colldamping
	
	if paticle.pos.x + radius > box.end.x :
		paticle.pos.x = box.end.x - radius
		paticle.velocity.x *= -1 * PhysicProp.colldamping
	if paticle.pos.x - radius < box.position.x :
		paticle.pos.x = box.position.x + radius
		paticle.velocity.x *= -1 * PhysicProp.colldamping

func ready_paticles():
	pass

func _draw():
	draw_rect(box,Color.GREEN,true)
#	for par in paticles :
#		draw_circle(par.pos,radius,color)

func smooth_kernel(rad,dis):
	var volum = PI * pow(rad,8)/4
	var val = max(0,rad * rad - dis * dis)
	return val * val * val / volum
	
func cal_desity(sample_point:PhyPaticle):
	var dens = 0
	for p in paticles :
		if p != sample_point :
			var dis = (sample_point.pos - p.pos).length()
			var influent = smooth_kernel(smooth_radius,dis)
			dens += mass * influent
	
	return dens

func _input(event):
	if Input.is_action_pressed("click") :
		var pos = get_global_mouse_position() 
		var sample = PhyPaticle.new(pos)
		var dens = cal_desity(sample) * 100
		print(dens)
