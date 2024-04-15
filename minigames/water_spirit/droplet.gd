extends Area2D
class_name Droplet

signal target_hit

@export var acceleration : float = 200.0
@export var travel_limit : float = 40.0

@export var target : Node2D

var speed : float = 0.0
var distance_traveled : float = 0.0

func _physics_process(delta):
	speed += acceleration * delta;
	var direction = Vector2.DOWN.rotated(self.rotation)

	self.position += direction * speed * delta
	self.distance_traveled += speed * delta
	
	if self.distance_traveled > self.travel_limit:
		queue_free()

func _on_body_entered(body):
	if body == target:
		target_hit.emit()
