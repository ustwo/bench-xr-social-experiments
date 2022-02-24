using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GravityScale : MonoBehaviour
{
    [SerializeField]
    private Vector3 gravity;

    void Start()
    {
        Physics.gravity = gravity;
    }
}
