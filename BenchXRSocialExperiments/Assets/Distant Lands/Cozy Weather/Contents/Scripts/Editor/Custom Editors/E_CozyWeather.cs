using UnityEditor;

namespace DistantLands.Cozy.EditorScripts
{
    [CustomEditor(typeof(CozyWeather))]
    [CanEditMultipleObjects]
    public class E_CozyWeather : Editor
    {

        SerializedProperty atmo;
        SerializedProperty weather;
        SerializedProperty annual;


        SerializedProperty lockToCamera;
        SerializedProperty allowRuntimeChanges;
        SerializedProperty sunDirection;
        SerializedProperty sunPitch;
        SerializedProperty weatherTransitionSpeed;

        SerializedProperty stars;
        SerializedProperty clouds;




        void OnEnable()
        {
            atmo = serializedObject.FindProperty("m_AtmosphereProfile");
            weather = serializedObject.FindProperty("m_WeatherProfile");
            annual = serializedObject.FindProperty("m_PerennialProfile");

            lockToCamera = serializedObject.FindProperty("lockToCamera");
            allowRuntimeChanges = serializedObject.FindProperty("allowRuntimeChanges");
            sunDirection = serializedObject.FindProperty("sunDirection");
            sunPitch = serializedObject.FindProperty("sunPitch");
            weatherTransitionSpeed = serializedObject.FindProperty("weatherTransitionSpeed");

            stars = serializedObject.FindProperty("m_Stars");
            clouds = serializedObject.FindProperty("m_CloudParticles");


        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();
            EditorGUILayout.PropertyField(atmo);
            EditorGUILayout.PropertyField(weather);
            EditorGUILayout.PropertyField(annual);

            EditorGUILayout.Space(20);

            EditorGUILayout.PropertyField(lockToCamera);
            EditorGUILayout.PropertyField(allowRuntimeChanges);
            EditorGUILayout.PropertyField(sunDirection);
            EditorGUILayout.PropertyField(sunPitch);
            EditorGUILayout.PropertyField(weatherTransitionSpeed);

            EditorGUILayout.Space();

            EditorGUILayout.HelpBox("Looking for tick settings? Check out the new perennial profile!", MessageType.Info, true);


            EditorGUILayout.PropertyField(stars);
            EditorGUILayout.PropertyField(clouds);

            serializedObject.ApplyModifiedProperties();


        }


    }
}