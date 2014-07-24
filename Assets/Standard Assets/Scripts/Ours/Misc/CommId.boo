class CommId (): 

	//static public LocalPlayer = "<local>"
	

	static public LocalPlayer:
		get:
			if Network.peerType == NetworkPeerType.Disconnected:
				Debug.LogError("No network ID, not connected!")
			return Network.player.ToString()
