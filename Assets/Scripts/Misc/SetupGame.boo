import UnityEngine

class SetupGame (MonoBehaviour): 
	
	class Player:
		public index as string
		public callsign as string
		def __init__(index_ as string, callsign_ as string):
			index = index_
			callsign = callsign_
	
	//public numberOfPlayers as int = 3
	public playerBase as Transform
	public playerPrefab as Transform
	public center as Transform
	public basePrefab as Transform
	public copterPrefab as Transform
	
	_players as List
	_playerPos as int
	_playerObj as Transform

	def Awake():
		playerBase.gameObject.active = true
	
	def OnEnable ():
		God.Inst.Hermes.Listen(MessageStartGame, self)
	
	def OnDisable ():
		God.Inst.Hermes.StopListening(MessageStartGame, self)
	
	def OnMsgStartGame(msg as MessageStartGame):
		Debug.Log("Game started with ${msg.players.Count} players")
		Random.seed = msg.seed
		GeneratePlayersList(msg.players)
		SetupGame();
		Begin()
	
	def GeneratePlayersList(players as Hash):
		playerIndexes as List = List(players.Keys)
		playerIndexes.Sort()
		//ShuffleList(playerIndexes)
		ORandom.Shuffle(playerIndexes)
		_playerPos = playerIndexes.IndexOf(Network.player.ToString())
		_players = []
		for playerIndex in playerIndexes:
			player = Player()
			player.index = playerIndex
			player.callsign = players[playerIndex]
			_players.Add(player)
		/*for p as Player in _players:
			Debug.Log("*** ${p.index}, ${p.callsign}")*/
		Debug.Log("*** playerPos: ${_playerPos}")
	
	/*def ShuffleList(list as List):
		for i in range(len(list) - 1):
			for j in range(i + 1, len(list)):
				if Random.value < 0.5:
					//Debug.Log("swapping ${i} and ${j}")
					x = list[i]
					list[i] = list[j]
					list[j] = x*/
	
	def SetupGame():
		//Debug.Log("Setting up game for ${numberOfPlayers} players...")
		_playerObj = Instantiate(playerPrefab, Vector3.zero, Quaternion.identity)
		SetupPlayerBase()
		//CreateEnemyBases()
		EnableGUI()
	
	def SetupPlayerBase():
		// calculate rotation
		numberOfPlayers = len(_players)
		centerOnPlayerBaseLevel = center.position
		centerOnPlayerBaseLevel.y = playerBase.transform.position.y
		angle = 360.0 / numberOfPlayers
		playerRotation = Quaternion.AngleAxis(angle * _playerPos, Vector3.up)
		
		// instantiate base
		//player as Player = _players[_playerPos]
		playerBase.gameObject.active = false
		baseFromCenter = playerBase.transform.position - centerOnPlayerBaseLevel
		Debug.Log("Instantiating player base...")
		base as Transform = Network.Instantiate(basePrefab, centerOnPlayerBaseLevel + playerRotation * baseFromCenter, playerRotation, 0)
		//base.GetComponent(CommObj).playerId = player.callsign
		base.GetComponent(CommObj).playerId = CommId.LocalPlayer
		base.GetComponent(CommObj).netPlayer = Network.player
		//base.gameObject.active = true
		base.gameObject.GetComponent(DeployGround).fund = _playerObj.Find("Fund").GetComponent(Fund)
		base.gameObject.GetComponent(DeployCopter).copterPrefab = copterPrefab
		base.gameObject.name = "Base${_playerPos + 1}"
		
		// orbit camera
		Camera.main.GetComponent(CameraFollow).Reset()
		cameraPos = Camera.main.transform.position - playerBase.position
		cameraPos = playerRotation * cameraPos
		Camera.main.transform.position = base.position + cameraPos
		Camera.main.transform.rotation = playerRotation * Camera.main.transform.rotation

	/*def CreateEnemyBases():
		numberOfPlayers = len(_players)
		
		centerOnPlayerBaseLevel = center.position
		centerOnPlayerBaseLevel.y = playerBase.transform.position.y
		
		baseFromCenter = playerBase.transform.position - centerOnPlayerBaseLevel
		angle = 360.0 / numberOfPlayers
		
		for i in range(1, numberOfPlayers):
			player as Player = _players[(_playerPos + i) % numberOfPlayers]
			Debug.Log("Creating player ${player.callsign}'s base")
			rotation = Quaternion.AngleAxis(angle * i, Vector3.up)
			base as Transform = Instantiate(basePrefab, centerOnPlayerBaseLevel + rotation * baseFromCenter, rotation)
			base.gameObject.name = "BaseEnemy${i + 1}"
			base.GetComponent(CommObj).playerId = player.callsign
			*/
	
	def EnableGUI():
		// TODO: turn on LivesText, Help, Fund.Text
		pass
	
	def Begin():
		_playerObj.Find("Lives").GetComponent(PlayerLives).Deploy()
