extends Node

signal exp_pickup(exp: int)
signal start_game
signal next_color_requested
signal change_color_requested(color: Color)
signal exit_shop
signal experience_added(new_value: int)
signal experience_updated(value: int, max_value: int)
signal next_wave(new_wave_number: int)
signal primary_color_change(new_color: Color)
signal request_camera_shake(trauma: int)
