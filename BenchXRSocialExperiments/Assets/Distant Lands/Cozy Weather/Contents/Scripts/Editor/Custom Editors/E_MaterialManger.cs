using UnityEditor;

namespace DistantLands.Cozy.EditorScripts
{

    [CustomEditor(typeof(CozyMaterialManager))]
    [CanEditMultipleObjects]
    public class E_MaterialManger : Editor
    {
        SerializedProperty m_SnowAmount;
        SerializedProperty m_SnowMeltSpeed;
        SerializedProperty m_Wetness;

        SerializedProperty m_DryingSpeed;
        SerializedProperty useRainbow;
        SerializedProperty profile;


        void OnEnable()
        {
            m_SnowAmount = serializedObject.FindProperty("m_SnowAmount");


            m_SnowMeltSpeed = serializedObject.FindProperty("m_SnowMeltSpeed");
            m_Wetness = serializedObject.FindProperty("m_Wetness");

            m_DryingSpeed = serializedObject.FindProperty("m_DryingSpeed");
            useRainbow = serializedObject.FindProperty("useRainbow");
            profile = serializedObject.FindProperty("profile");

        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();


            EditorGUILayout.PropertyField(profile);
            EditorGUILayout.PropertyField(m_SnowAmount);
            EditorGUILayout.PropertyField(m_SnowMeltSpeed);
            EditorGUILayout.PropertyField(m_Wetness);
            EditorGUILayout.PropertyField(m_DryingSpeed);
            EditorGUILayout.PropertyField(useRainbow);



            serializedObject.ApplyModifiedProperties();


        }
    }
}