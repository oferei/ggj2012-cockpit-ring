import UnityEngine

class CCWiseWrapper (MonoBehaviour): 

	def Start ():
		gameObject.GetComponentInChildren(RingMove).angularSpeed = -gameObject.GetComponentInChildren(RingMove).angularSpeed
