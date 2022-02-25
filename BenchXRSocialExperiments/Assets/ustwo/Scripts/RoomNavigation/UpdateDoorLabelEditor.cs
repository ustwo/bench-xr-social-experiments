using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

[ExecuteInEditMode]
public class UpdateDoorLabelEditor : MonoBehaviour
{
    public TextMeshProUGUI doorLabel;

    void Update()
    {
        var goToSceneName = this.gameObject.GetComponent<DoorToRoom>().goToScene;
        doorLabel.text = $"To: {goToSceneName}";
    }
}
