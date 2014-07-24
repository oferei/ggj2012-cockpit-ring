import UnityEngine

class Base (MonoBehaviour): 
	
	def Dead ():
		Debug.Log("Enemy base ${CommObj.GetPlayerId(transform)} destroyed!")
