import UnityEngine

class Sensor (MonoBehaviour): 

	def OnTriggerEnter(other as Collider):
		gameObject.SendMessageUpwards("_OnTriggerEnter", other, SendMessageOptions.DontRequireReceiver)
		
	def OnTriggerStay (other as Collider):
		gameObject.SendMessageUpwards("_OnTriggerStay", other, SendMessageOptions.DontRequireReceiver)
	
	def OnTriggerExit (other as Collider):
		gameObject.SendMessageUpwards("_OnTriggerExit", other, SendMessageOptions.DontRequireReceiver)
