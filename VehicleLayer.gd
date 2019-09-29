extends CanvasLayer

var vehicles = [
	load("res://vehicles/PoliceVehicle.tscn"),
	load("res://vehicles/RedVehicle.tscn"),
	load("res://vehicles/TruckVehicle.tscn")
]

func _ready():
	randomize()

func add_vehicle():
	var packedscene = vehicles[randi() % 3]
	var vehicle = packedscene.instance()
	add_child(vehicle)