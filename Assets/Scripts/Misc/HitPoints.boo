import UnityEngine

class HitPoints (MonoBehaviour): 
	
	public hitPoints as single = 1

	def ApplyDamage(damage as single):
		//Debug.Log("Hit! had ${hitPoints} hit points")
		hitPoints -= damage
		if hitPoints <= 0:
			SendMessageUpwards("Dead", null, SendMessageOptions.DontRequireReceiver)
			Destroy(gameObject)
