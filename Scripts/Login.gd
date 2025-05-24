extends Node

func _ready() -> void:
	# This will control which logs you get from EOSG
	HLog.log_level = HLog.LogLevel.INFO

	var init_opts = EOS.Platform.InitializeOptions.new()
	var create_opts = EOS.Platform.CreateOptions.new()
	
	init_opts.product_name = "MusGroups - Client" # Change this
	init_opts.product_version = "0.1.52" # Change this

	create_opts.product_id = Private.product_id
	create_opts.sandbox_id = Private.sandbox_id
	create_opts.deployment_id = Private.deployment_id
	create_opts.client_id = Private.client_id
	create_opts.client_secret = Private.client_secret
	create_opts.encryption_key = Private.encryption_key

	# Enable Social Overlay on Windows
	if OS.get_name() == "Windows":
		HAuth.auth_login_flags = EOS.Auth.LoginFlags.None
		create_opts.flags = EOS.Platform.PlatformFlags.WindowsEnableOverlayOpengl

	# Initialize the SDK
	var init_res := await HPlatform.initialize_async(init_opts)
	if not EOS.is_success(init_res):
		printerr("Failed to initialize EOS SDK: ", EOS.result_str(init_res))
		return
	
	# Create platform
	var create_success := await HPlatform.create_platform_async(create_opts)
	if not create_success:
		printerr("Failed to create EOS Platform")
		return

	# Setup Logs from EOS
	MusGroups.setupLogging()
	
	# This will control which logs you get from EOS SDK
	var log_res := HPlatform.set_eos_log_level(EOS.Logging.LogCategory.AllCategories, EOS.Logging.LogLevel.Info)
	if not EOS.is_success(log_res):
		printerr("Failed to set logging level")
		return

	HAuth.logged_in.connect(_on_logged_in)

	# During development use the devauth tool to login
	devLogin()
	# Only on mobile device (Login without any credentials)
	# await HAuth.login_anonymous_async()

func devLogin() -> void:
	if OS.is_debug_build():
		var args = OS.get_cmdline_args()
		for i in args:
			match i:
				"server":
					HAuth.login_devtool_async("localhost:8877", "host")
				"client":
					HAuth.login_devtool_async("localhost:8877", "client")

func _on_logged_in():
	print("Logged in successfully: product_user_id=%s" % HAuth.product_user_id)
	get_tree().change_scene_to_packed(preload("res://Scenes/mainMenu.tscn"))
