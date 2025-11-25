extends GutTest

# Test suite for UILayer functionality

var UILayer = preload("res://scripts/ui_layer.gd")
var ui_layer_instance = null

func before_each():
	# Create a fresh UI layer instance before each test
	ui_layer_instance = autoqfree(CanvasLayer.new())
	ui_layer_instance.set_script(UILayer)

func after_each():
	ui_layer_instance = null

func test_ui_layer_initialization():
	assert_not_null(ui_layer_instance, "UI layer instance should be created")

func test_ui_layer_is_canvas_layer():
	assert_true(ui_layer_instance is CanvasLayer, "UI layer should be a CanvasLayer")

func test_ui_layer_ready():
	# Add to scene tree and call _ready
	add_child_autoqfree(ui_layer_instance)
	ui_layer_instance._ready()

	# Just verify it doesn't crash
	pass_test("UI layer _ready should execute without errors")
