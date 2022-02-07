using UnityEditor;

namespace DistantLands.Cozy.EditorScripts
{

    [CustomEditor(typeof(CozyLightningManager))]
    [CanEditMultipleObjects]
    public class E_LightningManager : Editor
    {
        SerializedProperty lightningPrefab;


        void OnEnable()
        {
            lightningPrefab = serializedObject.FindProperty("lightningPrefab");



        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();
            EditorGUILayout.PropertyField(lightningPrefab);
            serializedObject.ApplyModifiedProperties();


        }
    }
}