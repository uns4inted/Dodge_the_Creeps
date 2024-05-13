extends Node

@export var mob_scene: PackedScene;
var score;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func game_over():
	$Music.stop();
	$DeathSound.play();
	$ScoreTimer.stop();
	$MobTimer.stop();
	$HUD.show_game_over();
	
func new_game():
	$Music.play();
	
	score = 0;
	
	$Player.start($StartPosition.position);
	$StartTimer.start();
	
	$HUD.update_score(score);
	$HUD.show_message("Get Ready");
	
	get_tree().call_group("mobs", "queue_free");


func _on_mob_timer_timeout():
	# create new instance of mob scene
	var mob = mob_scene.instantiate();
	
	# set random location on Path2d
	var mob_spawn_location = $MobPath/MobSpawnLocation;
	mob_spawn_location.progress_ratio = randf();
	
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
	$HUD.update_score(score);


func _on_start_timer_timeout():
	$MobTimer.start();
	$ScoreTimer.start();
