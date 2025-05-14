class_name MobSpawner
extends WorldComponent

@export var min_player_distance: int= 50



func start():
	$Timer.start()


func _on_timer_timeout():
    if not enabled: return
    
    var tile: Vector2i

    
    var player_pos = Global.game.player.get_tile_pos()
    
    var spawn_range = 30  
    
    tile = Vector2i(
        player_pos.x + randi_range(-spawn_range, spawn_range),
        player_pos.y + randi_range(-spawn_range, spawn_range)
    )
    
    var mob_def: MobDefinition = DataManager.mobs.pick_random()
    var spawner: MobSpawnerDefinition = mob_def.spawner
    
    if spawner and spawner.can_spawn(tile, world):
        var other_mob: BaseMob = get_world().get_closest_mob(tile)
        if other_mob:
            var dist: float = other_mob.distance_to_tile(tile)
            if dist < spawner.min_distance_to_other:
                return
            elif other_mob.type == mob_def and dist < spawner.min_distance_to_same:
                return
            
            other_mob = get_world().get_closest_mob(tile, mob_def)
            if dist < spawner.min_distance_to_same:
                return
        
        world.spawn_mob(mob_def, tile)


func get_world()-> World:
	return get_parent()
