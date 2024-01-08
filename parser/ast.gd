class_name AST

# Base interface for a token that can be parsed from a string
class Token:
	func _init(tokens: String):
		assert(not tokens.empty(), "Can't parse an empty token")

# Named identifier token
class Ident extends Token:
	var ident: String
	func _init(tokens: String).(tokens):
		ident = tokens

	func _to_string() -> String:
		return "Ident(%s)" % ident

# Base interface for a command parameter
class Param extends Token:
	var ident: Ident

	func _init(tokens: String).(tokens):
		ident = Ident.new(tokens)

	func _to_string() -> String:
		return "Param(%s)" % ident.to_string()

# List of Param objects
class Params extends Token:
	var params: Array

	func _init(tokens: String).(tokens):
		var token_array = tokens.split(" ")
		for token in token_array:
			params.append(Param.new(token))

	func _to_string() -> String:
		var string = "Params [\n"
		for param in params:
			string += "\t\t\t%s,\n" % param
		string += "\t\t]"
		return string

# A scripting language command
class Command extends Token:
	var ident: Ident
	var params: Params

	func _init(tokens: String).(tokens):
		var token_array = tokens.split(" ")
		assert(token_array.size() > 0, "Can't parse an empty command")
		ident = Ident.new(token_array[0])
		token_array.remove(0)

		if token_array.size() > 0:
			params = Params.new(token_array.join(" "))

	func string() -> String:
		var string = "{\n\t\tident: %s\n" % [ident]
		string += "\t\tparams: %s\n" % [params]
		string += "\t}"
		return string

	# Static function for parsing a command with a given type
	static func parse(tokens: String):
		var token_array = tokens.split(" ")
		assert(token_array.size() > 0, "Can't parse an empty command")
		match token_array[0]:
			"waitfor":
				return WaitForCommand.new(tokens)
			"weld":
				return WeldCommand.new(tokens)
			"look":
				return LookCommand.new(tokens)


# Command that waits for an event
class WaitForCommand extends Command:
	func _init(tokens: String).(tokens):
		pass

	func _to_string() -> String:
		return "\t WaitForCommand " + string()

# Command that waits for an event
class WeldCommand extends Command:
	func _init(tokens: String).(tokens):
		pass

	func _to_string() -> String:
		return "\t WeldCommand " + string()

# Command that waits for an event
class LookCommand extends Command:
	func _init(tokens: String).(tokens):
		pass

	func _to_string() -> String:
		return "\t LookCommand " + string()

# Chain of commands that execute in sequence
class PipeList extends Token:
	var children: Array

	func _init(tokens: String).(tokens):
		var token_array = tokens.split("|")
		assert(token_array.size() > 0, "Can't parse an empty pipe list")
		for i in range(0, token_array.size()):
			var token = token_array[i].strip_edges()
			children.append(Command.parse(token))

	func _to_string() -> String:
		var string = "PipeList [\n"
		for child in children:
			string += "%s,\n" % child.to_string()
		string += "]\n"
		return string
