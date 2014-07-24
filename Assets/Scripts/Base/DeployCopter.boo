import UnityEngine

class DeployCopter (MonoBehaviour): 

	public copterPrefab as Transform
	
	_spawnPoint as Transform
	_exitPoint as Transform

	def Awake ():
		_spawnPoint = transform.Find("Copter spawn")
		assert _spawnPoint
		_exitPoint = transform.Find("Copter exit")
		assert _exitPoint

	def OnEnable ():
		God.Inst.Hermes.Listen(MessageDeployCopter, self)
	
	def OnDisable ():
		God.Inst.Hermes.StopListening(MessageDeployCopter, self)
	
	def OnMsgDeployCopter(msg as MessageDeployCopter):
		return if msg.playerId != CommObj.GetPlayerId(transform)
		
		// deploy
		//copter = Instantiate(copterPrefab, _spawnPoint.position, _spawnPoint.rotation)
		copter = Network.Instantiate(copterPrefab, _spawnPoint.position, _spawnPoint.rotation, 0)
		//copter.gameObject.name = "Copter1"
		copter.GetComponent(CopterStart).Deploy(_exitPoint.position)
		CommObj.SetPlayerId(transform, copter)
		copter.gameObject.active = true
