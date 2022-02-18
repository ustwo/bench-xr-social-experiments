using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Normal.Realtime;
using TMPro;

public class AvatarParamSync : RealtimeComponent<AvatarParamModel>
{
    public TextMeshProUGUI playerNameText;
    public Transform characterModelContainer;
    public List<Material> characterSkinMaterials;

    private int modelIndex;
    private int materialIndex;
    private string playerName;
    private static string[] adjectives = new string[] { "Magical", "Cool", "Nice", "Funny", "Fancy", "Glorious", "Weird", "Awesome" };
    private static string[] nouns = new string[] { "Weirdo", "Guy", "Santa Claus", "Dude", "Mr. Nice Guy", "Dumbo" };


    private bool _isSelf;

    public int CharacterModelIndex => model.characterModelIndex;
    public int CharacterMaterialIndex => model.characterMaterialIndex;
    public string Nickname => model.nickname;


    private void Awake()
    {
        if (GetComponent<RealtimeAvatar>().isOwnedLocallyInHierarchy)
        {
            _isSelf = true;

            playerName = adjectives[Random.Range(0, adjectives.Length)] + " " + nouns[Random.Range(0, nouns.Length)];
            modelIndex = Random.Range(0, characterModelContainer.childCount - 2);
            materialIndex = Random.Range(0, characterSkinMaterials.Count);

            // assigment to model which broadcasts to the server and other clients
            model.nickname = playerName; // assign player name
            model.characterModelIndex = modelIndex; // assign player model by index
            model.characterMaterialIndex = materialIndex; //assign player material by index
        }
    }

    protected override void OnRealtimeModelReplaced(AvatarParamModel previousModel, AvatarParamModel currentModel)
    {
        if (previousModel != null)
        {
            // Unregister from events
            previousModel.nicknameDidChange -= NicknameDidChange;
            previousModel.characterModelIndexDidChange -= CharacterModelIndexDidChange;
            previousModel.characterMaterialIndexDidChange -= CharacterMaterialIndexDidChange;
        }

        if (currentModel != null)
        {
            if (currentModel.isFreshModel)
            {
                currentModel.nickname = "";
            }

            UpdatePlayerName();
            DisablePrevModelAtIndex(previousModel.characterModelIndex);

            currentModel.nicknameDidChange += NicknameDidChange;
            currentModel.characterModelIndexDidChange += CharacterModelIndexDidChange;
            currentModel.characterMaterialIndexDidChange += CharacterMaterialIndexDidChange;
        }
    }

    private void NicknameDidChange(AvatarParamModel model, string nickname)
    {
        UpdatePlayerName();
    }

    private void UpdatePlayerName()
    {
        // Update the UI
        playerNameText.text = model.nickname;
    }

    private void CharacterModelIndexDidChange(AvatarParamModel model, int index)
    {
        UpdatePlayerName();
    }

    private void ShowModelAtIndex()
    {
        //characterModelContainer.GetChild(model.characterModelIndex).gameObject.SetActive(true);
    }

    private void DisablePrevModelAtIndex(int index)
    {
        characterModelContainer.GetChild(index).gameObject.SetActive(false);
    }

    private void CharacterMaterialIndexDidChange(AvatarParamModel model, int index)
    {
        // model.characterMaterialIndex
    }

    private void UpdateMaterialShowing()
    {

    }
}
