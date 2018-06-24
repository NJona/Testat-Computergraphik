using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BallShoot : MonoBehaviour
{
    public GameObject Prefab;
    public GameObject Cube;

    void Start()
    {
        Prefab = Resources.Load("ball") as GameObject;
    }

    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            GameObject ball = Instantiate(Prefab) as GameObject;
            ball.AddComponent<SphereCollider>();
            ball.AddComponent<BallCollider>();
            ball.GetComponent<BallCollider>().Cube = Cube;
            //ball.AddComponent<ForceFieldSimulator>();
            //ball.GetComponent<ForceFieldSimulator>().cube = GameObject.FindGameObjectWithTag("Cube");
            ball.transform.position = transform.position + Camera.main.transform.forward * 2;
            Rigidbody rb = ball.GetComponent<Rigidbody>();
            rb.velocity = Camera.main.transform.forward * 40;
        }
    }

    //// Update is called once per frame
    //void Update () {
    //       if (cube != null)
    //       {
    //           Vector4 pos = new Vector4(gameObject.transform.position.x, gameObject.transform.position.y, gameObject.transform.position.z, 1);
    //           cube.GetComponent<MeshRenderer>().material.SetVector("_WindSourcePosition", pos);
    //       }
    //   }
}