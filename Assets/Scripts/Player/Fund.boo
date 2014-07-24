import UnityEngine

class Fund (MonoBehaviour): 
	
	public initial as single = 50
	
	_money as single
	_playerId as string
	_text as GUIText

	def Awake ():
		_text = transform.Find("Text").guiText
		assert _text
		_money = initial
		UpdateText()
	
	def Start():
		_playerId = CommObj.GetPlayerId(transform)
	
	def OnEnable ():
		God.Inst.Hermes.Listen(MessageEarnMoney, self)
	
	def OnDisable ():
		God.Inst.Hermes.StopListening(MessageEarnMoney, self)
	
	def OnMsgEarnMoney(msg as MessageEarnMoney):
		return if msg.playerId != _playerId
		
		_money += msg.amount
		UpdateText()
	
	def Spend (amount as single) as bool:
		if _money < amount:
			return false
		_money -= amount
		UpdateText()
		return true
	
	def UpdateText():
		// round down
		_text.text = "Money: ${(_money - 0.5).ToString('0')}"
