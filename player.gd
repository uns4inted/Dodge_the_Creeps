extends Area2D


@export var speed = 400; # pixels/sec
var screen_size;
signal hit;

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size;
	hide();


func start(pos):
	position = pos;
	show();
	$CollisionShape2D.disabled = false;
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# 1.check for input
	var velocity = Vector2.ZERO; # players movement vector
	if (Input.is_action_pressed("move_up")):
		velocity.y -= 1;
	if (Input.is_action_pressed("move_down")):
		velocity.y += 1;
	if (Input.is_action_pressed("move_left")):
		velocity.x -= 1;
	if (Input.is_action_pressed("move_right")):
		velocity.x += 1;
	
	# 2.move in given direction
	if (velocity.length() > 0):
		velocity = velocity.normalized() * speed;
		$AnimatedSprite2D.play();
	else:
		$AnimatedSprite2D.stop(); 
	
	position += velocity * delta;
	position = position.clamp(Vector2.ZERO, screen_size); #prevent player from leaving screen

	# 3.play the appropriate animation
	if (velocity.x != 0):
		$AnimatedSprite2D.animation = "walk";
		$AnimatedSprite2D.flip_v = false;
		$AnimatedSprite2D.flip_h = velocity.x < 0;
	if (velocity.y != 0):
		$AnimatedSprite2D.animation = "up";
		$AnimatedSprite2D.flip_v = velocity.y > 0;
		
	


func _on_body_entered(body):
	hide();
	hit.emit();
	$CollisionShape2D.set_deferred("disabled", true);

