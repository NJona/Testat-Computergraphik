using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PlayerControls : MonoBehaviour {

    // Movement Speed
    public float movementSpeed = 1f;
    // Rotation Speed
    public float rotationSpeed = 150f;
        

	// Use this for initialization
	void Start () {
        
		
	}
	
	// Update is called once per frame
	void Update () {
        KeyboardController();
        MouseController();
	}

    void MouseController()
    {
        // Get Horizontal Mouse Movement
        // Rotate Player
        transform.Rotate(0f, Input.GetAxis("Mouse X") * Time.deltaTime * rotationSpeed, 0f);
    }

    void KeyboardController()
    {
        // Get Horizontal and Vertical Translation Commands from Keyboard
        // Move PlayerObject with Time
        transform.Translate(Input.GetAxis("Horizontal") * Time.deltaTime * movementSpeed , 0f, Input.GetAxis("Vertical") * Time.deltaTime * movementSpeed);

        //Catch Escape Key to open Menu
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            SceneManager.LoadScene(0);
        }
    }
}
