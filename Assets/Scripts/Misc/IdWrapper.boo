import UnityEngine

class IdWrapper (MonoBehaviour): 

	public playerId as string
	
	def Awake ():
		gameObject.GetComponentInChildren(CommObj).playerId = playerId
