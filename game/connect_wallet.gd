extends Button

func _ready():
	if Ethers.is_wallet_available():
		print_debug("Wallet is available")
	else:
		print_debug("No wallet available, please install metamask")
		text = "No wallet extension found, please install Metamask or Rabby wallet."


func _on_pressed():
	Ethers.connect_wallet()
