extends Node

func _ready() -> void:
	var example_input = "waitfor mouse1 | look | weld | waitfor mouse1 | look"
	var pipe_list = AST.PipeList.new(example_input)
	print(pipe_list)
