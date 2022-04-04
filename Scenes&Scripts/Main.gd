extends Node2D

var startRect : Area2D;
var endRect : Area2D; 
var startRectClicked : bool = false;
var endRectClicked : bool = false; #Might be redundant.

var cycleCounter : int;
var stopWatch : float;
var cycleTimes : Array = [];
var gameWidth : int;
var gamePos : int;

var gameResults: Array= [];


export(int) var cyclesPerGame : int = 8;
var gameRectSettings : Array = [Vector2(300, 350), Vector2(200, 200), Vector2(200, 300), Vector2(200, 500), Vector2(100, 150), Vector2(100, 300), Vector2(100, 550), Vector2(40, 150), Vector2(40, 250), Vector2(40, 350), Vector2(40, 550), Vector2(20, 150), Vector2(20, 250), Vector2(20, 350), Vector2(20, 450), Vector2(20, 550)] #X is Width, Y is Position.
var randGen : RandomNumberGenerator;

var rectColours : Dictionary = {"unclicked": Color("ff0000"), "clicked": Color("630000")};



var turnOffEverything : bool = false

var jsonData : String;




func _ready():
	randGen = RandomNumberGenerator.new();
	randGen.randomize();
	$"Game Counter".update_text();





var rectSettingsCopy : Array = gameRectSettings.duplicate();

func start_game():
	if turnOffEverything:
		return
	$"Next Game".visible = false;
	var i : int = randGen.randi_range(0, rectSettingsCopy.size()-1);
	var transform : Vector2 = rectSettingsCopy[i];
	gameWidth = transform.x;
	gamePos = transform.y;
	rectSettingsCopy.remove(i);
	$"Rect R".position.x = transform.y;
	$"Rect L".position.x = -transform.y;
#	___________________________________________________________
	$"Rect R/CollisionShape2D".shape.extents.x = 0.5*transform.x;
#	___________________________________________________________
	$"Rect R/TextureRect".rect_position.x = -0.5 * transform.x;
	$"Rect L/TextureRect".rect_position.x = -0.5 * transform.x;
#	___________________________________________________________
	$"Rect R/TextureRect".rect_size.x = transform.x;
	$"Rect L/TextureRect".rect_size.x = transform.x;
#	___________________________________________________________
	$"Rect R".visible = true;
	$"Rect L".visible = true;
	$"Rect L".modulate = rectColours["unclicked"];
	$"Rect R".modulate = rectColours["unclicked"];
	
	
	$"Cycle Counter".update_counter(str(cycleCounter)+"/" + str(cyclesPerGame));
	


func set_start_rect(rect: Area2D):
	if turnOffEverything:
		return
	startRect = rect;
	if startRect == $"Rect L":
		endRect = $"Rect R";
	elif startRect == $"Rect R":
		endRect = $"Rect L";
	else:
		print("Something strange is happening at set_start_rect().");
		print("Argument = ", rect, "\n", $"Rect L", $"Rect R");
	startRectClicked = true;



func process_rect_click(rect: Area2D):
	if turnOffEverything:
		return
	if startRect == null:
		set_start_rect(rect);
		rect.modulate = rectColours["clicked"];
		return
	if rect == startRect:
		startRectClicked = true;
		rect.modulate = rectColours["clicked"];
		endRect.modulate = rectColours["unclicked"];
	elif startRectClicked == true:
		rect.modulate = rectColours["clicked"];
		startRect.modulate = rectColours["unclicked"];
		cycleCounter += 1;
		$"Cycle Counter".update_counter(str(cycleCounter)+"/" + str(cyclesPerGame));
		startRectClicked = false;
		cycleTimes.append(stopWatch);
		stopWatch = 0;
		if cycleCounter >= cyclesPerGame:
			end_game();



func end_game():
	$"Game Counter".update_text();
	$"Next Game".visible = true;
	
	get_results();
	reset_game();
	if rectSettingsCopy.size() == 0:
		turnOffEverything = true;
		print("The experiment is done!");
		jsonData = JSON.print(gameResults,"\t");
		print("this is json data:\n"+jsonData)
		


func get_results():
	var averageTime : float;
	for i in cycleTimes:
		averageTime += i;
	averageTime /= cycleTimes.size();
	gameResults.append({"Width": gameWidth, "Amplitude": gamePos*2, "Cycle times": cycleTimes, "Average time": averageTime});
	



func reset_game():
	$"Rect L".visible = false;
	$"Rect R".visible = false;
	$Home.visible = true;
	startRect = null;
	endRect = null
	startRectClicked = false;
	endRectClicked = false;
	stopWatch = 0;
	cycleTimes = [];
	cycleCounter = 0;





func _process(delta):
	stopWatch += delta;


func _unhandled_key_input(event):
	
	if event is InputEventKey:
		if event.scancode == 16777221:
			print("Cycle Times:");
			print(cycleTimes);
			print("Test results:")
			print(gameResults);
		
		if event.scancode == 67:
			save_results();
	









func save_results():
	var fh : File = File.new();
	fh.open("user://results.json", File.WRITE);
	fh.store_string(jsonData);
	fh.close();
	print("We saved the results as results.json file")
	














