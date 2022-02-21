using UnityEditor;

namespace DistantLands.Cozy.EditorScripts
{

    [CustomEditor(typeof(CozyClimate))]
    [CanEditMultipleObjects]
    public class E_CozyClimate : Editor
    {

        SerializedProperty climateProfile;
        SerializedProperty tempratureFilter;
        SerializedProperty precipitationFilter;

        SerializedProperty currentTemprature;
        SerializedProperty currentTempratureCelsius;
        SerializedProperty currentPrecipitation;


        void OnEnable()
        {
            climateProfile = serializedObject.FindProperty("climateProfile");


            tempratureFilter = serializedObject.FindProperty("tempratureFilter");
            precipitationFilter = serializedObject.FindProperty("precipitationFilter");

            currentTemprature = serializedObject.FindProperty("currentTemprature");
            currentTempratureCelsius = serializedObject.FindProperty("currentTempratureCelsius");
            currentPrecipitation = serializedObject.FindProperty("currentPrecipitation");

        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();
            EditorGUILayout.PropertyField(climateProfile);


            EditorGUILayout.PropertyField(tempratureFilter);
            EditorGUILayout.PropertyField(precipitationFilter);

            EditorGUILayout.Space();

            EditorGUILayout.PropertyField(currentTemprature);
            EditorGUILayout.PropertyField(currentTempratureCelsius);
            EditorGUILayout.PropertyField(currentPrecipitation);


            serializedObject.ApplyModifiedProperties();


        }
    }
}