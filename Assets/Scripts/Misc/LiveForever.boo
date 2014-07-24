import UnityEngine

class LiveForever (MonoBehaviour): 
	
	public recursive = true

	def Start ():
		if recursive:
			for child as Transform in gameObject.GetComponentsInChildren(Transform):
				Object.DontDestroyOnLoad(child)
		else:
			Object.DontDestroyOnLoad(gameObject)
