extends Node

@export var mob_scene: PackedScene;
var score;

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func game_over():
	$ScoreTimer.stop();
	$MobTimer.stop();
	
func new_game():
	score = 0;
	$Player.start($StartPosition.position);
	$StartTimer.start();


func _on_mob_timer_timeout():
	# create new instance of mob scene
	var mob = mob_scene.instantiate();
	
	# set random location on Path2d
	var mob_spawn_location = $MobPath/MobSpawnLocation;
	
	# set mob's direction perpendicular to the path direction
	var direction = mob_spawn_location.rotation + PI / 2;
	
	# set mob's position to random location
	mob.position = mob_spawn_location.position;
	
	# add randomness to the direction
	direction += randf_range(-PI / 4, PI / 4);
	mob.rotation = direction;  
	
	# set velocity for the mob
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0);
	mob.linear_velocity = velocity.rotated(direction);
	
	# spawn the mob on main scene
	add_child(mob); 


func _on_score_timer_timeout():
	score += 1;


func _on_start_timer_timeout():
	$MobTimer.start();
	$ScoreTimer.start();
