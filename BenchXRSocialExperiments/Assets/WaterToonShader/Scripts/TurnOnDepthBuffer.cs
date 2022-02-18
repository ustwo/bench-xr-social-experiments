using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class TurnOnDepthBuffer : MonoBehaviour
{
    // Use this for initialization
    void Start()
    {
        var camera = GetComponent<Camera>();
        camera.depthTextureMode = DepthTextureMode.Depth;
    }
}
