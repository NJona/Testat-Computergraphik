using UnityEngine;

namespace Assets.A1_Deformation.Scripts
{
    public class CollisionDetection : MonoBehaviour
    {

        public int DeformationTimeToLive;
        public int MaxNumberOfDeformations;
        public float ForceMultiplier;
        private float[] _timeToLiveArray;
        private Vector4[] _positionArray;

        public void OnCollisionEnter(Collision collision)
        {
            //get Deformation position
            var position = new Vector4(collision.gameObject.transform.position.x,
                collision.gameObject.transform.position.y, collision.gameObject.transform.position.z, 1);

            //move last deformation to one index earlier (newest deformation is at index MaxNumberDeformations - 1)
            for (var i = 0; i < MaxNumberOfDeformations - 1; i++)
            {
                _timeToLiveArray[i] = _timeToLiveArray[i + 1];
                _positionArray[i] = _positionArray[i + 1];
            }

            //add newest deformation at last array index
            _timeToLiveArray[MaxNumberOfDeformations - 1] = DeformationTimeToLive;
            _positionArray[MaxNumberOfDeformations - 1] = position;

            GetComponent<MeshRenderer>().material.SetFloatArray("_deformationTimeToLiveList", _timeToLiveArray);
            GetComponent<MeshRenderer>().material.SetVectorArray("_collisionPositionList", _positionArray);
        }

        public void Start()
        {
            //check MaxNumberOfDeformations and assign 100 if number is out of shader range (shader range is hard coded to 100)
            if (MaxNumberOfDeformations > 100 || MaxNumberOfDeformations <= 0)
            {
                Debug.Log("MaxNumerOfDeformation not specified or bigger than 100. Use default value '100' instead.");
                MaxNumberOfDeformations = 100; //100 is Max Array Count in Shader
            }

            if (DeformationTimeToLive == 0)
            {
                Debug.Log("DeformationTimeToLive not specified. Use default value '100' instead");
                DeformationTimeToLive = 100;
            }

            //check if ForceMultiplier is too small and asign 1 if
            if (ForceMultiplier < 0.1f)
            {
                Debug.Log(
                    "ForceMultiplier is less than '0.1'. Please assign Values bigger than '0.1'. Use default value '1' instead");
                ForceMultiplier = 1;
            }

            _timeToLiveArray = new float[MaxNumberOfDeformations];
            _positionArray = new Vector4[MaxNumberOfDeformations];

            //initialize Array with default values
            for (var i = 0; i < MaxNumberOfDeformations; i++)
            {
                _timeToLiveArray[i] = 0;
                _positionArray[i] = new Vector4(0, 0, 0, 0);
            }

            GetComponent<MeshRenderer>().material.SetFloatArray("_deformationTimeToLiveList", _timeToLiveArray);
            GetComponent<MeshRenderer>().material.SetVectorArray("_collisionPositionList", _positionArray);
            GetComponent<MeshRenderer>().material.SetFloat("_deformationTimeToLive", DeformationTimeToLive);
            GetComponent<MeshRenderer>().material.SetFloat("_forceMultiplier", ForceMultiplier);
        }

        public void Update()
        {
            for (var i = 0; i < _timeToLiveArray.Length; i++)
            {
                //skip time to live, if 0
                if (!(_timeToLiveArray[i] > 0))
                {
                    continue;
                }

                //decrement time to live, to make deformation smaller
                _timeToLiveArray[i] = _timeToLiveArray[i] - 1f;
                GetComponent<MeshRenderer>().material.SetFloatArray("_deformationTimeToLiveList", _timeToLiveArray);
            }
        }
    }
}
