using UnityEditor;

namespace DistantLands.Cozy.EditorScripts
{

    [CustomEditor(typeof(CozyAmbienceManager))]
    [CanEditMultipleObjects]
    public class E_AmbienceManager : Editor
    {
        SerializedProperty m_Ambiences;
        SerializedProperty currentAmbienceProfile;


        void OnEnable()
        {
            m_Ambiences = serializedObject.FindProperty("m_Ambiences");


            currentAmbienceProfile = serializedObject.FindProperty("currentAmbienceProfile");

        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();
            EditorGUILayout.PropertyField(m_Ambiences);
            EditorGUILayout.Space();
            EditorGUILayout.PropertyField(currentAmbienceProfile);


            serializedObject.ApplyModifiedProperties();


        }
    }
}