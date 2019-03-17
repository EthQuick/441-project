#Based on this tutorial: http://docs.godotengine.org/en/3.0/getting_started/step_by_step/singletons_autoload.html
extends Node

var player_key = 0
var player_coins = 0
var total_coins = 0

func world_end():
	total_coins += player_coins
	player_coins = 0

func game_start():
	player_key = 0
	player_coins = 0
	total_coins = 0