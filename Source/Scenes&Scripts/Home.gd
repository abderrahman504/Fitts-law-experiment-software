extends Area2D

signal clicked;

var mouseIn : bool = false;


func _ready():
	connect("clicked", get_parent(), "start_game");


func _on_Home_mouse_entered():
	mouseIn = true;


func _on_Home_mouse_exited():
	mouseIn = false;


func _unhandled_input(event):
	
	if mouseIn:
		if event is InputEventMouse:
			if event.button_mask == BUTTON_LEFT:
				emit_signal("clicked");
				set_deferred("visible", false);
				mouseIn = false;

