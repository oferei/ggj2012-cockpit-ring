import UnityEngine

class AutoHeight (MonoBehaviour): 
	
	public target as Transform
	
	def Start ():
		transform.position.y = target.position.y
