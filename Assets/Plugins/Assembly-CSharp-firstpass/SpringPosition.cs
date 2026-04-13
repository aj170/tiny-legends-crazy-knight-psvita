using UnityEngine;

public class SpringPosition : IgnoreTimeScale
{
	public bool ignoreTimeScale;

	private float mThreshold;

	private Transform mTrans;

	public float strength = 10f;

	public Vector3 target = Vector3.zero;

	public bool worldSpace;

	public static SpringPosition Begin(GameObject go, Vector3 pos, float strength)
	{
		SpringPosition springPosition = go.GetComponent<SpringPosition>();
		if (springPosition == null)
		{
			springPosition = go.AddComponent<SpringPosition>();
		}
		springPosition.target = pos;
		springPosition.strength = strength;
		if (!springPosition.enabled)
		{
			springPosition.mThreshold = 0f;
			springPosition.enabled = true;
		}
		return springPosition;
	}

	private void Start()
	{
		mTrans = base.transform;
	}

	private void Update()
	{
		float deltaTime = ((!ignoreTimeScale) ? Time.deltaTime : UpdateRealTimeDelta());
		if (worldSpace)
		{
			if (mThreshold == 0f)
			{
				mThreshold = (target - mTrans.position).magnitude * 0.001f;
			}
			mTrans.position = MyMath.SpringLerp(mTrans.position, target, strength, deltaTime);
			Vector3 vector = target - mTrans.position;
			if (mThreshold >= vector.magnitude)
			{
				mTrans.position = target;
				base.enabled = false;
			}
		}
		else
		{
			if (mThreshold == 0f)
			{
				mThreshold = (target - mTrans.localPosition).magnitude * 0.001f;
			}
			mTrans.localPosition = MyMath.SpringLerp(mTrans.localPosition, target, strength, deltaTime);
			Vector3 vector2 = target - mTrans.localPosition;
			if (mThreshold >= vector2.magnitude)
			{
				mTrans.localPosition = target;
				base.enabled = false;
			}
		}
	}
}
