using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class FollowOffset
{
    public Transform vrTarget;
    public Transform rigTarget;
    public Vector3 trackingPositionOffset;
    public Vector3 trackingRotationOffset;

    public void Update()
    {
        rigTarget.position = vrTarget.TransformPoint(trackingPositionOffset);
        rigTarget.rotation = vrTarget.rotation * Quaternion.Euler(trackingRotationOffset);
    }
}
public class AvatarFollow : MonoBehaviour
{
    public float turnSmoothness = 1;
    public FollowOffset head;
    public FollowOffset leftHand;
    public FollowOffset rightHand;

    public Transform headConstraint;
    public Vector3 headBodyOffset;

    void Start()
    {
        headBodyOffset = transform.position - headConstraint.position;
    }

    void Update()
    {
        transform.position = headConstraint.position + headBodyOffset;
        transform.forward = Vector3.Lerp(transform.forward,
         Vector3.ProjectOnPlane(headConstraint.up, Vector3.up).normalized, Time.deltaTime * turnSmoothness);

        head.Update();
        leftHand.Update();
        rightHand.Update();
    }
}