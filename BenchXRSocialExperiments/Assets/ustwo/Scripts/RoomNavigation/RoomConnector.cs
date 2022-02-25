using System.Collections;
using System.Collections.Generic;
using Normal.Realtime;
using UnityEngine;
using UnityEngine.SceneManagement;

public class RoomConnector : MonoBehaviour
{
    private Realtime realtime;
    private string roomName;
    private bool sceneLoading = false;
    
    void Start()
    {
        realtime = FindObjectOfType<Realtime>();
    }

    public void ReloadSceneAndConnectRoom(string newRoomName)
    {
        if (sceneLoading) return;
        roomName = newRoomName;
        StartCoroutine(LoadAsyncScene());
    }

    IEnumerator LoadAsyncScene()
    {
        sceneLoading = true;
        realtime.Disconnect();
        realtime = null;

        AsyncOperation asyncLoad = SceneManager.LoadSceneAsync(roomName);
        while (!asyncLoad.isDone)
        {
            yield return null;
        }
        
        realtime = FindObjectOfType<Realtime>();
        realtime.Connect(roomName);

        sceneLoading = false;
    }
}
