extends Control

@onready var scene: String = "res://editor.tscn"

func _ready() -> void:
	%Login.pressed.connect(loginPressed)
	%Register.pressed.connect(registerPressed)
	
	Firebase.Auth.login_succeeded.connect(onLoginSucceeded)
	Firebase.Auth.signup_succeeded.connect(onRegisterSucceeded)
	
	Firebase.Auth.login_failed.connect(onLoginFailed)
	Firebase.Auth.signup_failed.connect(onRegisterFailed)
	
	if Firebase.Auth.check_auth_file():
		%Label.set_text("login is successful") 
		get_tree().change_scene_to_file(scene)

func loginPressed():
	
	var email = %Email.text
	var password = %Password.text
	Firebase.Auth.login_with_email_and_password(email, password)
	%Label.set_text("Loggin in")

func registerPressed():
	var email = %Email.text
	var password = %Password.text
	
	Firebase.Auth.signup_with_email_and_password(email, password)
	%Label.set_text("Signing up")

func onLoginSucceeded(auth):
	print(auth)
	%Label.set_text("Logged in successfully")
	Firebase.Auth.save_auth(auth)
	get_tree().change_scene_to_file(scene)
	

func onRegisterSucceeded(auth):
	print(auth)
	%Label.set_text("Registered in successfully")
	Firebase.Auth.save_auth(auth)
	get_tree().change_scene_to_file(scene)
	

func onLoginFailed(error_code, message):
	print(error_code)
	print(message) 
	%Label.set_text("Login failed. Error:" + message)

func onRegisterFailed(error_code, message):
	print(error_code)
	print(message) 
	%Label.set_text("Singup failed. Error:" + message)
	
