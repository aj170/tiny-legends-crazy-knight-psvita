using UnityEngine;

public class UIViewPort : MonoBehaviour
{
	public Camera sourceCamera;

	public Transform topLeft;

	public Transform bottomRight;

	public float fullSize = 160f;

	private Camera mCam;

	private static Rect rect;

	private void Start()
	{
		mCam = base.GetComponent<Camera>();
		if (sourceCamera == null)
		{
			sourceCamera = Camera.main;
		}
		if (topLeft != null && bottomRight != null)
		{
			Vector3 vector = sourceCamera.WorldToScreenPoint(topLeft.position);
			Vector3 vector2 = sourceCamera.WorldToScreenPoint(bottomRight.position);
			rect = new Rect(vector.x / (float)Screen.width, vector2.y / (float)Screen.height, (vector2.x - vector.x) / (float)Screen.width, (vector.y - vector2.y) / (float)Screen.height);
			float num = 160f * rect.height;
			if (rect != mCam.rect)
			{
				mCam.rect = rect;
			}
			if (mCam.orthographicSize != num)
			{
				mCam.orthographicSize = num;
			}
		}
	}

	public static Rect GetViewRect()
	{
		return rect;
	}

	private void LateUpdate()
	{
	}
}
