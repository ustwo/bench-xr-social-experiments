using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class DoorToRoom : MonoBehaviour
{
    public String goToScene;
    private RoomConnector roomConnector;
    private string roomName;

    void Start()
    {
        roomConnector = FindObjectOfType<RoomConnector>();
        roomName = goToScene;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            roomConnector.ReloadSceneAndConnectRoom(roomName);
        }
    }
}
