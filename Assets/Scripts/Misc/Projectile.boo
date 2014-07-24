import UnityEngine

class Projectile (MonoBehaviour): 
	
	//public direction as Vector3
	public damage as single = 1
	public ignoreLayerMask as int = 0
	
	public explosion as Transform
	
	def OnCollisionEnter(collisionInfo as Collision):
		//Debug.Log("BOOM! hit ${collisionInfo.gameObject.name}")
		
		if ignoreLayerMask & 1 << collisionInfo.gameObject.layer:
			return
		
		//Debug.Log("friendlyFire: ${CommObj.AreFriendly(transform, collisionInfo.transform)}")
		if not CommObj.AreFriendly(transform, collisionInfo.transform):
			collisionInfo.gameObject.SendMessageUpwards("ApplyDamage", damage, SendMessageOptions.DontRequireReceiver)
		
		contact = collisionInfo.contacts[0]
		//CreateBlast(contact.point)
		MakeExplosion(contact)
		
		Destroy(gameObject)
		
		/*
		// find the colliders inside a sphere of radius farAreaEffect
		    var colls = Physics.OverlapSphere(transform.position, farAreaEffect);
		    for (var col: Collider in colls){
		        if (col.CompareTag("British")){ // if it's a bloody British...
		            // calculate the distance from the impact...
		            var distance = Vector3.Distance(col.transform.position, transform.position);
		            var damage = farDamage; // assume farDamage initially...
		            if (distance <= closeAreaEffect){
		                damage = closeDamage; // but if inside close area, change to max damage
		            }
		            else 
		            if (distance <= mediumAreaEffect){
		                damage = mediumDamage; // else if inside medium area, change to medium damage
		            }
		            // apply the selected damage
		            col.SendMessage("ApplyDamage", damage, SendMessageOptions.DontRequireReceiver);
		        }
		    }
		*/
	
	def CreateBlast(point as Vector3):
		for obj in Physics.OverlapSphere(point, 15):
			if obj.rigidbody:
				obj.rigidbody.AddExplosionForce(100, point, 15, 0, ForceMode.Impulse)

	def MakeExplosion(contact as ContactPoint):
		rotation = Quaternion.FromToRotation(Vector3.up, contact.normal)
		/*instantiatedExplosion = */Instantiate(explosion, contact.point, rotation)
