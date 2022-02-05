using UnityEditor;

namespace DistantLands.Cozy.EditorScripts
{
    [CustomEditor(typeof(CozyCalendar))]
    [CanEditMultipleObjects]
    public class E_CozyCalendar : Editor
    {

        SerializedProperty resetTicksOnStart;
        SerializedProperty startTicks;
        SerializedProperty monthName;
        SerializedProperty formattedTime;




        void OnEnable()
        {
            resetTicksOnStart = serializedObject.FindProperty("resetTicksOnStart");
            startTicks = serializedObject.FindProperty("startTicks");


            monthName = serializedObject.FindProperty("monthName");
            formattedTime = serializedObject.FindProperty("formattedTime");

        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();
            EditorGUILayout.PropertyField(resetTicksOnStart);
            if (resetTicksOnStart.boolValue == true)
            EditorGUILayout.PropertyField(startTicks);


            EditorGUILayout.PropertyField(monthName);
            EditorGUILayout.PropertyField(formattedTime);

            EditorGUILayout.Space();

            EditorGUILayout.HelpBox("Looking for temprature settings? Check out the new climate module!", MessageType.Info, true);

            serializedObject.ApplyModifiedProperties();


        }


    }
}