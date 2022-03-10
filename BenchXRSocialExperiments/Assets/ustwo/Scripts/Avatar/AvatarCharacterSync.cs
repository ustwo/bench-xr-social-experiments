using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Normal.Realtime;

public class AvatarCharacterSync : RealtimeComponent<AvatarCharacterModel>
{

    public Transform characterModelContainer;
    public List<Material> characterSkinMaterials;

    private bool _isSelf;

    //public int CharacterModelIndex => model.characterModelIndex;
    //public int CharacterMaterialIndex => model.characterMaterialIndex;


    void Start()
    {
        if (GetComponent<RealtimeAvatar>().isOwnedLocallyInHierarchy)
        {
            _isSelf = true;
        }

        model.characterModelIndex = Random.Range(0, characterModelContainer.childCount - 2);
        model.characterMaterialIndex = Random.Range(0, characterSkinMaterials.Count);

        Debug.Log("model.characterModelIndex: " + model.characterModelIndex);
        Debug.Log("Random.Range(0, characterModelContainer.childCount - 2): " + Random.Range(0, characterModelContainer.childCount - 2));

        //UpdateModelShowing(model.characterModelIndex);

    }

    protected override void OnRealtimeModelReplaced(AvatarCharacterModel previousModel, AvatarCharacterModel currentModel)
    {

        if (previousModel != null)
        {
            // Unregister from events
            //previousModel.characterModelIndexDidChange -= ModelDidUpdate;
            //previousModel.characterMaterialIndexDidChange -= MaterialDidUpdate;
            DisableModelAtIndex(previousModel.characterModelIndex);
            Debug.Log("previousModel.characterModelIndex: " + previousModel.characterModelIndex + " is disabled");

        }

        if (currentModel != null)
        {
            if (currentModel.isFreshModel)
            {
            }

            DisableModelAtIndex(currentModel.characterModelIndex);
            model.characterModelIndex = Random.Range(0, characterModelContainer.childCount - 2);

            ShowModelAtIndex(model.characterModelIndex);
            Debug.Log("currentModel.characterModelIndex: " + currentModel.characterModelIndex + " is enabled");


            //currentModel.characterModelIndexDidChange += ModelDidUpdate;
            //currentModel.characterMaterialIndexDidChange += MaterialDidUpdate;
        }
    }
    private void ModelDidUpdate(AvatarCharacterModel model, int modelIndex)
    {
        ShowModelAtIndex(modelIndex);
    }
    private void MaterialDidUpdate(AvatarCharacterModel model, int materialIndex)
    {
        UpdateMaterialShowing(materialIndex);
    }

    private void ShowModelAtIndex(int index)
    {
        characterModelContainer.GetChild(index).gameObject.SetActive(true);
    }

    private void DisableModelAtIndex(int index)
    {
        characterModelContainer.GetChild(index).gameObject.SetActive(false);
    }

    private void UpdateMaterialShowing(int index)
    {

    }
}
