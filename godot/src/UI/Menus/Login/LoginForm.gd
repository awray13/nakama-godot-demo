# Control panel that manages logging into an existing account.
extends Control

signal register_pressed
signal login_pressed(email, password, do_remember_email)

var is_enabled := true setget set_is_enabled

onready var remember_email := $RememberEmail

onready var email_field := $Email/LineEditValidate
onready var password_field := $Password/LineEditValidate
onready var login_button := $HBoxContainer/LoginButton
onready var register_button := $HBoxContainer/RegisterButton

onready var status_panel := $StatusPanel


func _ready() -> void:
	email_field.text = Connection.get_last_email()
	if not email_field.text.empty():
		remember_email.pressed = true

	email_field.grab_focus()


func set_is_enabled(value: bool) -> void:
	is_enabled = value
	if not email_field:
		yield(self, "ready")
	email_field.editable = is_enabled
	password_field.editable = is_enabled
	remember_email.disabled = not is_enabled
	login_button.disabled = not is_enabled
	register_button.disabled = not is_enabled


func update_status(text: String) -> void:
	status_panel.text = text


func _on_LoginButton_pressed() -> void:
	if not email_field.is_valid:
		status_panel.text = "The email address is not valid"
		return
	if password_field.text == "":
		status_panel.text = "Please enter your password to log in"
		return
	if password_field.text.length() < 8:
		status_panel.text = "The password should be at least 8 characters long"
		return

	emit_signal("login_pressed", email_field.text, password_field.text, remember_email.pressed)
	status_panel.text = "Authenticating..."


func _on_RegisterButton_pressed() -> void:
	emit_signal("register_pressed")
