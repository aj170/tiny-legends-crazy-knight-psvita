using UnityEngine;

public class MyGUIDragablePanel : IgnoreTimeScale
{
	public enum DragEffect
	{
		None = 0,
		Momentum = 1,
		MomentumAndSpring = 2
	}

	public enum ShowCondition
	{
		Always = 0,
		OnlyIfNeeded = 1,
		WhenDragging = 2
	}

	private bool mPressed;

	public bool restrictWithinPanel = true;

	public bool disableDragIfFits;

	public DragEffect dragEffect = DragEffect.MomentumAndSpring;

	public Vector2 scale = Vector2.one;

	public float momentumAmount = 35f;

	public Vector2 relativePositionOnReset = Vector2.zero;

	public bool repositionClipping;

	public ShowCondition showScrollBars = ShowCondition.OnlyIfNeeded;

	private Transform mTrans;

	private Plane mPlane;

	private Vector3 mLastPos;

	private Vector2 mMomentum = Vector2.zero;

	private float mScroll;

	private Bounds mBounds;

	private bool mCalculatedBounds;

	private bool mShouldMove;

	private bool mIgnoreCallbacks;

	private int mTouches;

	private float min;

	private float max;

	public TUIMeshSprite[] pageDot;

	private float delta;

	public void SetBounds(float start, float width)
	{
		max = start;
		min = start - width;
		delta = (max - min) / 3f;
	}

	private void Awake()
	{
		mTrans = base.transform;
		MyGUIEventListener.Get(base.gameObject).EventHandleOnMoved += OnMoved;
		MyGUIEventListener.Get(base.gameObject).EventHandleOnPressed += OnPressed;
		MyGUIEventListener.Get(base.gameObject).EventHandleOnReleased += OnReleased;
	}

	private void Start()
	{
	}

	public void RestrictWithinBounds(bool instant)
	{
		Vector3 zero = Vector3.zero;
		if (base.transform.localPosition.x > max)
		{
			zero.x = max - base.transform.localPosition.x;
		}
		if (base.transform.localPosition.x < min)
		{
			zero.x = min - base.transform.localPosition.x;
		}
		MoveRelative(zero);
		mMomentum = Vector3.zero;
		mScroll = 0f;
	}

	private void MoveRelative(Vector3 relative)
	{
		mTrans.localPosition += relative;
	}

	private void MoveAbsolute(Vector3 absolute)
	{
		Vector3 vector = mTrans.InverseTransformPoint(absolute);
		Vector3 vector2 = mTrans.InverseTransformPoint(Vector3.zero);
		MoveRelative(vector - vector2);
	}

	public void Press()
	{
		mTouches++;
		mPressed = true;
		mMomentum = Vector3.zero;
		mScroll = 0f;
	}

	private void OnMoved(GameObject go, Vector2 delta)
	{
		Drag(delta);
	}

	private void UpdateScrollBar()
	{
		if (base.transform.localPosition.x > max)
		{
			pageDot[0].frameName = "PageDot_d";
			pageDot[0].UpdateMesh();
			pageDot[1].frameName = "PageDot";
			pageDot[1].UpdateMesh();
			pageDot[2].frameName = "PageDot";
			pageDot[2].UpdateMesh();
		}
		else if (base.transform.localPosition.x < min)
		{
			pageDot[0].frameName = "PageDot";
			pageDot[0].UpdateMesh();
			pageDot[1].frameName = "PageDot";
			pageDot[1].UpdateMesh();
			pageDot[2].frameName = "PageDot_d";
			pageDot[2].UpdateMesh();
		}
		else
		{
			pageDot[0].frameName = "PageDot";
			pageDot[0].UpdateMesh();
			pageDot[1].frameName = "PageDot_d";
			pageDot[1].UpdateMesh();
			pageDot[2].frameName = "PageDot";
			pageDot[2].UpdateMesh();
		}
	}

	public void Drag(Vector2 delta)
	{
		mTrans.Translate(new Vector3(delta.x, 0f, 0f));
		UpdateScrollBar();
	}

	private Vector3 CalculateConstrainOffset()
	{
		Vector3 zero = Vector3.zero;
		if (mTrans.localPosition.x > max)
		{
			zero.x = mTrans.localPosition.x - max;
		}
		if (base.transform.localPosition.x < min)
		{
			zero.x = mTrans.localPosition.x - min;
		}
		return zero;
	}

	public bool ConstrainToBounds(bool immediate)
	{
		if (mTrans != null)
		{
			Vector3 vector = CalculateConstrainOffset();
			if (vector.magnitude > 0f)
			{
				if (immediate)
				{
					mTrans.localPosition -= vector;
				}
				else
				{
					SpringPosition springPosition = SpringPosition.Begin(base.gameObject, mTrans.localPosition - vector, 20f);
					springPosition.ignoreTimeScale = true;
					springPosition.worldSpace = false;
				}
				return true;
			}
		}
		return false;
	}

	public void Release(Vector2 pos)
	{
		mPressed = false;
		if (dragEffect == DragEffect.MomentumAndSpring)
		{
			ConstrainToBounds(false);
		}
	}

	private void OnPressed(GameObject go, Vector2 pos)
	{
		Press();
	}

	private void OnReleased(GameObject go, Vector2 pos)
	{
		Release(pos);
	}

	private void LateUpdate()
	{
	}
}
