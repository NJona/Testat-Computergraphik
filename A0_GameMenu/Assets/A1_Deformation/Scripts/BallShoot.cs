using UnityEngine;

public class BallShoot : MonoBehaviour {

    GameObject ball;
	
	void Start () {
        ball = Resources.Load("ball") as GameObject;
	}
	
	void Update () {
	    if (Input.GetMouseButtonDown(0))
        {
            GameObject ball = Instantiate(this.ball) as GameObject;
            ball.transform.position = transform.position + Camera.main.transform.forward * 2;
            Rigidbody rb = ball.GetComponent<Rigidbody>();
            rb.velocity = Camera.main.transform.forward * 40;
        }	
	}
}
