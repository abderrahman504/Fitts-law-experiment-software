extends Area2D

signal clicked;


var mouseIn : bool = false;

func _ready():
	connect("clicked", get_parent(), "process_rect_click")


func on_mouse_entered():
	mouseIn = true;


func on_mouse_exited():
	mouseIn = false;



func _unhandled_input(event):
	if mouseIn:
		if event is InputEventMouse:
			if event.button_mask == BUTTON_LEFT:
				emit_signal("clicked", self);
