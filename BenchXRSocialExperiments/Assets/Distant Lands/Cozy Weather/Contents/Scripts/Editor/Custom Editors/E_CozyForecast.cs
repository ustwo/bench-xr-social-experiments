using UnityEditor;

namespace DistantLands.Cozy.EditorScripts
{
    [CustomEditor(typeof(CozyForecast))]
    [CanEditMultipleObjects]
    public class E_CozyForecast : Editor
    {


        SerializedProperty forecast;
        SerializedProperty forecastProfile;


        void OnEnable()
        {
            forecast = serializedObject.FindProperty("forecast");
            forecastProfile = serializedObject.FindProperty("forecastProfile");

        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();
            EditorGUILayout.PropertyField(forecastProfile);
            EditorGUILayout.Space();
            EditorGUILayout.PropertyField(forecast);


            serializedObject.ApplyModifiedProperties();


        }
    }
}