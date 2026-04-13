using UnityEngine;

public class NetworkTransformInterpolation : MonoBehaviour
{

    [Header("Smoothing Settings")]
    public float smoothSpeed = 5f;

    private Vector3 targetPosition;
    private Quaternion targetRotation;
    private bool hasReceived;

    private void Update()
    {
        if (!hasReceived) return;

        transform.position = Vector3.Lerp(transform.position, targetPosition, Time.deltaTime * smoothSpeed);
        transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, Time.deltaTime * smoothSpeed);
    }
    public void StartReceiving()
    {

    }

    public void ReceivedTransform(NetworkTransform ntransform)
    {
        targetPosition = ntransform.Position;
        targetRotation = ntransform.Rotation;
        hasReceived = true;
    }
}
