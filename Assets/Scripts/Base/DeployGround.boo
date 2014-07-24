import UnityEngine

class DeployGround (MonoBehaviour): 
	
	public tankPrefab as Transform
	public tankCost as single = 4
	public aaPrefab as Transform
	public aaCost as single = 3
	public fund as Fund
	public deployDelay as single = 1
	
	_leftPad as Transform
	_rightPad as Transform
	_lastDeployTime as single = -100
	_queue = []

	def Awake ():
		_leftPad = transform.Find("Left pad")
		assert _leftPad
		_rightPad = transform.Find("Right pad")
		assert _rightPad

	def OnEnable ():
		God.Inst.Hermes.Listen(MessageDeployTank, self)
		God.Inst.Hermes.Listen(MessageDeployAA, self)
	
	def OnDisable ():
		God.Inst.Hermes.StopListening(MessageDeployTank, self)
		God.Inst.Hermes.StopListening(MessageDeployAA, self)
	
	def DeployQueued():
		// wait if needed
		now = Time.time
		timeSinceLast = now - _lastDeployTime
		if timeSinceLast < deployDelay:
			Invoke("DeployQueued", deployDelay - timeSinceLast)
			return
		_lastDeployTime = now
		
		//Debug.Log("Queue: ${_queue}")
		Invoke("Deploy" + _queue.Pop(0), 0)
	
	def OnMsgDeployTank(msg as MessageDeployTank):
		Debug.Log("OnMsgDeployTank msg.playerId=${msg.playerId}, id=${CommObj.GetPlayerId(transform)}")
		return if msg.playerId != CommObj.GetPlayerId(transform)
		Debug.Log("OnMsgDeployTank 2")
		
		if fund and not fund.Spend(tankCost):
			Debug.Log("Not enough money to deploy a tank!")
			return
		
		Debug.Log("Deploying a tank...")
		_queue.Add("Tank")
		//Debug.Log("Queue: ${_queue}")
		DeployQueued()
	
	def DeployTank():
		// deploy
		tank = InstantiateTank(_leftPad)
		tank = InstantiateTank(_rightPad)
		tank.GetComponent(RingMove).angularSpeed = -tank.transform.GetComponent(RingMove).angularSpeed
	
	def InstantiateTank(pad as Transform) as Transform:
		tank = Instantiate(tankPrefab, pad.position, pad.rotation)
		CommObj.SetPlayerId(transform, tank)
		return tank
	
	def OnMsgDeployAA(msg as MessageDeployAA):
		return if msg.playerId != CommObj.GetPlayerId(transform)
		
		if fund and not fund.Spend(aaCost):
			Debug.Log("Not enough money to deploy a missile launcher!")
			return
		
		Debug.Log("Deploying a missile launcher...")
		_queue.Add("AA")
		//Debug.Log("Queue: ${_queue}")
		DeployQueued()
	
	def DeployAA():
		// deploy
		aa = InstantiateAA(_leftPad)
		aa = InstantiateAA(_rightPad)
		aa.GetComponent(RingMove).angularSpeed = -aa.transform.GetComponent(RingMove).angularSpeed
	
	def InstantiateAA(pad as Transform) as Transform:
		aa = Instantiate(aaPrefab, pad.position, pad.rotation)
		CommObj.SetPlayerId(transform, aa)
		return aa
