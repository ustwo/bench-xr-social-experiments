using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class FollowOffset
{
    public Transform follow;
    public Transform target;
    public Vector3 position;
    public Vector3 rotation;

    public void Update()
    {
        target.position = follow.TransformPoint(position);
        target.rotation = follow.rotation * Quaternion.Euler(rotation);
    }
}
public class AvatarFollow : MonoBehaviour
{
    public FollowOffset head;
    public FollowOffset leftHand;
    public FollowOffset rightHand;

    public Transform headConstraint;
    public Vector3 headBodyOffset;

    void Update()
    {
        transform.forward = Vector3.ProjectOnPlane(headConstraint.forward, Vector3.up).normalized;
        transform.position = headConstraint.position + headBodyOffset;

        head.Update();
        leftHand.Update();
        rightHand.Update();
    }
}