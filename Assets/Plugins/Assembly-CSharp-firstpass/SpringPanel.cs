using UnityEngine;

public class SpringPanel : IgnoreTimeScale
{
	public Vector3 target = Vector3.zero;

	public float strength = 10f;

	private Transform mTrans;

	private float mThreshold;

	private MyGUIDragablePanel mDrag;

	private void Start()
	{
		mDrag = GetComponent<MyGUIDragablePanel>();
		mTrans = base.transform;
	}

	private void Update()
	{
		float deltaTime = UpdateRealTimeDelta();
		if (mThreshold == 0f)
		{
			mThreshold = (target - mTrans.localPosition).magnitude * 0.005f;
		}
		Vector3 localPosition = mTrans.localPosition;
		mTrans.localPosition = MyMath.SpringLerp(mTrans.localPosition, target, strength, deltaTime);
		Vector3 vector = mTrans.localPosition - localPosition;
		if (mThreshold >= (target - mTrans.localPosition).magnitude)
		{
			base.enabled = false;
		}
	}

	public static SpringPanel Begin(GameObject go, Vector3 pos, float strength)
	{
		SpringPanel springPanel = go.GetComponent<SpringPanel>();
		if (springPanel == null)
		{
			springPanel = go.AddComponent<SpringPanel>();
		}
		springPanel.target = pos;
		springPanel.strength = strength;
		if (!springPanel.enabled)
		{
			springPanel.mThreshold = 0f;
			springPanel.enabled = true;
		}
		return springPanel;
	}
}
