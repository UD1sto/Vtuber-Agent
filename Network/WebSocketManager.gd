extends Node
class_name WebSocketManager

@export var handshake_headers: PackedStringArray
@export var supported_protocols: PackedStringArray
var tls_options: TLSOptions = null

# Use WebSocketPeer to implement the client.
# var socket := WebSocketPeer.new()
# var last_state := WebSocketPeer.STATE_CLOSED
# var leftover_text: String = ""

# Signals from the client.
signal connected_to_server()
signal connection_closed()
signal message_received(message: Variant)
signal animation_requested(animation_type)  # Custom signal for animation commands.

# Add an HTTPRequest node & a Timer to poll the server periodically.
@onready var http_request := HTTPRequest.new()
@onready var poll_timer := Timer.new()

# Connects to the specified WebSocket URL.
func connect_to_url(url: String) -> int:
	# socket.supported_protocols = supported_protocols
	# socket.handshake_headers = handshake_headers
	# var err := socket.connect_to_url(url, tls_options)
	# if err != OK:
	# 	return err
	# last_state = socket.get_ready_state()
	return OK

# Sends a message over the WebSocket.
func send(message: String) -> int:
	if typeof(message) == TYPE_STRING:
		return OK
	return OK

# Returns the next message (if any).
func get_message() -> Variant:
	return null

# Closes the connection.
func close(code: int = 1000, reason: String = "") -> void:
	# socket.close(code, reason)
	# last_state = socket.get_ready_state()
	pass

# Clears the socket instance.
func clear() -> void:
	# socket = WebSocketPeer.new()
	# last_state = socket.get_ready_state()
	pass

# Returns the raw socket.
func get_socket() -> WebSocketPeer:
	return null

func _ready() -> void:
	# Instead of creating a WebSocketPeer, add and connect HTTPRequest:
	add_child(http_request)
	http_request.request_completed.connect(Callable(self, "_on_request_completed"))
	
	# Create a Timer so we can repeatedly check the server:
	add_child(poll_timer)
	poll_timer.wait_time = 5.0     # Poll every 5 seconds (adjust as needed)
	poll_timer.autostart = true
	poll_timer.timeout.connect(Callable(self, "_make_request"))
	poll_timer.start()   # Ensure timer is started
	
	print("HTTP-based manager _ready() called.")
	# Potentially emit_signal("connected_to_server") if you like.

# Called by the Timer to request movement commands from the server
func _make_request() -> void:
	print("Making HTTP request to server...")
	var err = http_request.request("http://147.93.114.240:8000/move")
	if err != OK:
		push_error("Failed to make HTTP request, error code: %d" % err)

# When the request completes, parse JSON and emit signals for animations
func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != OK:
		push_error("HTTP request failed, code: %d" % result)
		return

	var content = body.get_string_from_utf8()
	var data = JSON.parse_string(content)
	if typeof(data) == TYPE_DICTIONARY:
		if data.has("action") and data.has("type") and data["action"] == "animate":
			var anim_type = data["type"]
			print("Performing animation:", anim_type)
			emit_signal("animation_requested", anim_type)
		else:
			print("Server returned data:", data)
	else:
		print("JSON parse error with body:", content)

func _on_connected_to_server() -> void:
	print("We connected!")
