import UnityEngine

class PlayerLives (MonoBehaviour):
	
	public numLives as int = 3
	public deployDelay as single = 5
	public copterCost as single = 20
	public fund as Fund
	public output as GUIText
	public gameover as Transform
	
	_currentNumLives as int
	
	def Awake():
		gameover.gameObject.active = false
		_currentNumLives = numLives - 1
		UpdateText()

	def OnEnable ():
		God.Inst.Hermes.Listen(MessagePlayerDead, self)
		God.Inst.Hermes.Listen(MessageBuyCopter, self)
	
	def OnDisable ():
		God.Inst.Hermes.StopListening(MessagePlayerDead, self)
		God.Inst.Hermes.StopListening(MessageBuyCopter, self)
	
	def OnMsgPlayerDead(msg as MessagePlayerDead):
		if _currentNumLives > 0:
			--_currentNumLives
			UpdateText()
			Invoke("Deploy", deployDelay)
		else:
			NoMoreCopters()

	def Deploy():
		Debug.Log("deploying copter...")
		MessageDeployCopter(CommId.LocalPlayer)
	
	def NoMoreCopters():
		MessageGameOver()
		gameover.gameObject.active = true
	
	def OnMsgBuyCopter(msg as MessageBuyCopter):
		if not fund.Spend(copterCost):
			Debug.Log("Not enough money to buy a helicopter!")
			return
		
		Debug.Log("Bought an extra helicopter.")
		++_currentNumLives
		UpdateText()
	
	def UpdateText():
		output.text = "Helicopters: ${_currentNumLives}"
