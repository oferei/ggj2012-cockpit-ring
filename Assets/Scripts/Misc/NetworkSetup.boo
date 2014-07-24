import UnityEngine
import System.Collections

[RequireComponent(NetworkView)]

class NetworkSetup (MonoBehaviour):
	
	minNumPlayers as int = 2
	maxNumPlayers as int = 8
	maxCallsignLength as int = 20
	
	_playerCallsign as string = ""
	_remoteIP = "127.0.0.1"
	_remotePort = 25000
	_listenPort = 25000
	//_useNAT = false
	_yourIP = ""
	_yourPort = ""
	
	_players = {}
	_invalidPlayers = {}
	
	_firstShow = true
	
	_gameStarted = false
	_lastLevelPrefix as int = 0
	
	def Awake():
		// Network level loading is done in a separate channel.
		networkView.group = 1
		
		_playerCallsign = Callsigns.RandomCallsign()
	
	def OnGUI ():
		if Network.peerType == NetworkPeerType.Disconnected:
			OnGuiDisconnected()
		else:
			// TODO: treat NetworkPeerType.Connecting
			OnGuiConnected()
	
	def OnGuiDisconnected():
		_gameStarted = false
		
		// callsign
		GUI.contentColor = Color.black
		GUI.Label(Rect(20, 15, 50, 22), "Callsign:")
		GUI.contentColor = Color.white
		GUI.SetNextControlName("callsign")
		_playerCallsign = GUI.TextField(Rect(75, 15, 170, 22), _playerCallsign, maxCallsignLength)
		if _firstShow:
			_firstShow = false
			GUI.FocusControl("callsign")
		
		// connect client
		_remoteIP = GUI.TextField(Rect(130, 64, 110, 22), _remoteIP, 15)
		_remotePort = int.Parse(GUI.TextField(Rect(250, 64, 45, 22), _remotePort.ToString()))
		if GUI.Button(Rect(20, 60, 100, 30), "Connect"):
			ConnectClient()
			
		// start server
		_listenPort = int.Parse(GUI.TextField(Rect(130, 114, 45, 22), _listenPort.ToString()))
		if GUI.Button(Rect(20, 110, 100, 30), "Start Server"):
			StartServer()
			
	def OnGuiConnected():
		//Debug.Log("Network.connections (${Network.connections.Length}): ${Network.connections}")
		//for conn as NetworkPlayer in Network.connections:
		//	Debug.Log("Connected: ${conn.ToString()}")

		GUI.contentColor = Color.black
		if _gameStarted:
			GUI.Label(Rect(140, 20, 170, 40), "Callsign: ${_playerCallsign}")
		else:
			GUI.Label(Rect(140, 20, 270, 40), "Callsign: ${_playerCallsign}, Index: ${Network.player.ToString}")
		
		if Network.isServer:
			if _gameStarted:
				statusLine = "Connected (server)"
			else:
				ipaddress = Network.player.ipAddress
				port = Network.player.port.ToString()
				statusLine = "Waiting for players, IP Adress: ${ipaddress}:${port}"
				ShowConnectedPlayers()
				// Start Game button
				GUI.contentColor = Color.white
				GUI.enabled = _players.Count >= minNumPlayers
				if GUI.Button(Rect(20, 80, 100, 50), "Start Game"):
					SendGameStart()
					return
				GUI.enabled = true
		else:
			if _gameStarted:
				statusLine = "Connected"
			else:
				statusLine = "Connected, waiting for game to start..."
				ShowConnectedPlayers()
		GUI.contentColor = Color.black
		GUI.Label(Rect(140, 40, 500, 40), statusLine)
		
		GUI.contentColor = Color.white
		if GUI.Button(Rect(20, 15, 100, 50), "Disconnect"):
			// Disconnect from the server
			Network.Disconnect(200)

	def IsValidPlayerCallsign():
		return false if not _playerCallsign
		//return false if _playerCallsign == CommId.LocalPlayer
		return true

	def ConnectClient():
		if not IsValidPlayerCallsign():
			Debug.LogError("Invalid player callsign!")
			GUI.FocusControl("callsign")
			return
		
		_players = {}
		
		Debug.Log("connecting client... IP=${_remoteIP} port=${_remotePort}")
		nce = Network.Connect(_remoteIP, _remotePort)
		if nce != NetworkConnectionError.NoError:
			Debug.LogError("client not connected: ${nce}")

	def StartServer():
		if not IsValidPlayerCallsign():
			Debug.LogError("Invalid player callsign!")
			GUI.FocusControl("callsign")
			return
		
		_players = {}
		_invalidPlayers = {}
		
		useNAT = not Network.HavePublicAddress()
		Debug.Log("starting server... port=${_listenPort} NAT=${useNAT}")
		nce = Network.InitializeServer(maxNumPlayers - 1, _listenPort, useNAT)
		if nce != NetworkConnectionError.NoError:
			Debug.LogError("server not started: ${nce}")
			return
		
		_players[Network.player.ToString()] = _playerCallsign
		//networkView.RPC("UpdatePlayerCallsign", RPCMode.OthersBuffered, Network.player.ToString(), _playerCallsign)

	def OnConnectedToServer():
		Debug.Log("Connected to server")
		networkView.RPC("JoinWithCallsign", RPCMode.Server, _playerCallsign)
	
	def OnFailedToConnect(error as NetworkConnectionError):
		Debug.LogWarning("Could not connect to server: ${error}")
	
	def OnDisconnectedFromServer(info as NetworkDisconnection):
		Debug.LogWarning("Disconnected from server: ${info}")
		StopGame()
	
	def OnPlayerDisconnected(player as NetworkPlayer):
		playerIndex = player.ToString()
		if _players.ContainsKey(playerIndex):
			Debug.Log("Player left: ${playerIndex}, ${_players[playerIndex]}")
			_players.Remove(playerIndex)
			if _gameStarted:
				// tear down game
				Debug.LogWarning("Player Disconnected - stopping game")
				Network.Disconnect()
				StopGame()
		else:
			Debug.Log("Player kicked off: ${playerIndex}, ${_invalidPlayers[playerIndex]}")
	
	[RPC]
	def JoinWithCallsign(callsign as string, msgInfo as NetworkMessageInfo):
		playerIndex = msgInfo.sender.ToString()
		Debug.Log("Player joined: ${playerIndex}, ${callsign}")
		if _gameStarted:
			Debug.Log("Game already started, rejecting: ${playerIndex}, ${callsign}")
			_invalidPlayers[playerIndex] = callsign
			Network.CloseConnection(msgInfo.sender, true)
		else:
			callsignIsTaken = _players.ContainsValue(callsign)
			if callsignIsTaken:
				Debug.Log("Callsign is taken, rejecting: ${playerIndex}, ${callsign}")
				_invalidPlayers[playerIndex] = callsign
				Network.CloseConnection(msgInfo.sender, true)
			else:
				SendPlayersList(msgInfo.sender)
				_players[playerIndex] = callsign
				networkView.RPC("UpdatePlayerCallsign", RPCMode.Others, playerIndex, callsign)
	
	def SendPlayersList(target as NetworkPlayer):
		for player in _players:
			networkView.RPC("UpdatePlayerCallsign", target, player.Key, player.Value)
	
	[RPC]
	def UpdatePlayerCallsign(playerIndex as string, callsign as string):
		//Debug.Log("UpdatePlayerCallsign: playerIndex=${playerIndex}, callsign=${callsign}")
		_players[playerIndex] = callsign
	
	def ShowConnectedPlayers():
		playerIndexes = List(_players.Keys)
		playerIndexes.Sort()
		top = 80
		height = 20
		GUI.contentColor = Color.black
		for playerIndex in playerIndexes:
			GUI.Label(Rect(140, top, 170, 100), "${playerIndex}: ${_players[playerIndex]}")
			top += height
	
	def SendGameStart():
		assert _players.Count >= minNumPlayers
		Network.RemoveRPCsInGroup(0)
		Network.RemoveRPCsInGroup(1)
		networkView.RPC("StartGame", RPCMode.All, _lastLevelPrefix + 1, Random.seed)
	
	def StopGame():
		Debug.Log("Game stopped")
		_gameStarted = false
		Application.LoadLevel("Empty")
	
	[RPC]
	def StartGame(levelPrefix as int, seed as int):
		StartCoroutine(StartGameCo(levelPrefix, seed))
	
	def StartGameCo(levelPrefix as int, seed as int) as IEnumerator:
		Debug.Log("Game started! levelPrefix=${levelPrefix}, seed=${seed}")
		_gameStarted = true
		_lastLevelPrefix = levelPrefix
		
		// There is no reason to send any more data over the network on the default channel,
		// because we are about to load the level, thus all those objects will get deleted anyway
		Network.SetSendingEnabled(0, false)
		
		// We need to stop receiving because first the level must be loaded first.
		// Once the level is loaded, rpc's and other state update attached to objects in the level are allowed to fire
		Network.isMessageQueueRunning = false
		
		// All network views loaded from a level will get a prefix into their NetworkViewID.
		// This will prevent old updates from clients leaking into a newly created scene.
		Network.SetLevelPrefix(levelPrefix)
		
		Application.LoadLevel("Empty")
		yield
		yield
		
		// Allow receiving data again
		Network.isMessageQueueRunning = true
		// Now the level has been loaded and we can start sending out data to clients
		Network.SetSendingEnabled(0, true)
		
		//for go in FindObjectsOfType(GameObject):
		//	go.SendMessage("OnNetworkLoadedLevel", SendMessageOptions.DontRequireReceiver)
		
		if _gameStarted:
			MessageStartGame(seed, _players)
	
	/*
	def OnLevelWasLoaded(level as int):
		if _gameStarted:
			MessageStartGame(_players)
*/
