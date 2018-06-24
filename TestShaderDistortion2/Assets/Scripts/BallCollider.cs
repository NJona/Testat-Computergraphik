using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BallCollider : MonoBehaviour
{
    public GameObject Cube;

	// Use this for initialization
    public void Start () {
		
	}
	
	// Update is called once per frame
    public void Update () {
		
	}

    public void OnCollisionEnter(Collision collision)
    {
        Vector4 pos = new Vector4(gameObject.transform.position.x, gameObject.transform.position.y, gameObject.transform.position.z, 1);
        Cube.GetComponent<MeshRenderer>().material.SetVector("_WindSourcePosition", pos);
    }
}
