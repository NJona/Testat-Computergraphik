using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ForceFieldSimulator : MonoBehaviour {

    public GameObject cube;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        
    }
	
	void OnCollisionEnter(Collision collision) {
		foreach (ContactPoint contact in collision.contacts) {		
			if (cube != null)
			{
				Vector4 pos = new Vector4(contact.point.x, contact.point.y, contact.point.z, 1);
				cube.GetComponent<MeshRenderer>().sharedMaterial.SetVector("_WindSourcePosition", pos);
			}
		}
	}
}
