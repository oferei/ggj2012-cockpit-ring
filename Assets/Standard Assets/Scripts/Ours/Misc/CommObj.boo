import UnityEngine

class CommObj (MonoBehaviour): 

	//public localPlayer as bool = false
	public playerId:
		get:
			return _playerId
		set:
			MissMe.IgnoreFriendlyCollisions(self, false) if _playerId
			//Debug.Log("Setting player ID of ${gameObject.name} to ${value}")
			_playerId = value
			MissMe.IgnoreFriendlyCollisions(self, true)if _playerId
	public _playerId as string
	//public playerId as string
	
	public netPlayer:
		get:
			return _netPlayer
		set:
			// TODO: make playerId obsolete
			_netPlayer = value
	public _netPlayer as NetworkPlayer

/*
	def Awake():
		if localPlayer:
			playerId = CommId.LocalPlayer
			*/

	//def Start():
	def OnEnable():
		MissMe.IgnoreFriendlyCollisions(self, true) if _playerId

	static def GetPlayerId(obj as Transform) as string:
		while obj:
			commObj = obj.GetComponent(CommObj)
			if commObj:
				return commObj.playerId
			obj = obj.parent
		return null
	
	static def SetPlayerId(from_ as Transform, to as Transform):
		to.gameObject.GetComponent(CommObj).playerId = GetPlayerId(from_)
	
	static def AreFriendly(obj1 as Transform, obj2 as Transform) as bool:
		id1 = GetPlayerId(obj1)
		return false if id1 == null
		id2 = GetPlayerId(obj2)
		return false if id2 == null
		
		return id1 == id2

	def OnNetworkInstantiate(info as NetworkMessageInfo):
		Debug.Log("OnNetworkInstantiate: obj=${gameObject.name} sender=${info.sender.ToString()}")
		//Debug.Log("info.networkView.viewID: ${info.networkView.viewID}")
		//Debug.Log("isMine: ${info.networkView.isMine}")
		//Debug.Log("Network.player: ${Network.player} ${Network.player == info.sender}")
		/*
		networkViews as (NetworkView) = GetComponents[of NetworkView]()
		Debug.Log('New prefab network instantiated with views - ')
		for view as NetworkView in networkViews:
			Debug.Log(('- ' + view.viewID))
			*/
	
	def OnSerializeNetworkView(stream as BitStream, info as NetworkMessageInfo):
		stream.Serialize(_netPlayer)
		if stream.isReading:
			Debug.Log("received network player: ${_netPlayer}")
