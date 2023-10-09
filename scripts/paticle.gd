extends Node
class_name PhyPaticle

var pos:Vector2 = Vector2(200,100)
var velocity = Vector2.ZERO

func _init(posi:Vector2):
	pos = posi

func update(delta):
	velocity += Vector2.DOWN * PhysicProp.gravity * delta
	pos += velocity * delta
