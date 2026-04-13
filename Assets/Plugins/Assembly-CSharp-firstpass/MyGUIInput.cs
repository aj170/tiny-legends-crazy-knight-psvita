using System.Collections.Generic;
using UnityEngine;

public class MyGUIInput : MonoBehaviour
{
	public enum ClickNotification
	{
		None = 0,
		Always = 1,
		BasedOnDelta = 2
	}

	public class TouchState
	{
		public ClickNotification clickNotification;

		public float clickTime;

		public GameObject current;

		public Vector2 delta;

		public Vector2 pos;

		public GameObject pressed;

		public Vector2 totalDelta;

		public TouchState()
		{
			clickNotification = ClickNotification.Always;
		}
	}

	public static Camera currentCamera = null;

	public static TouchState currentTouch = null;

	public static int currentTouchID;

	public LayerMask eventReceiverMask;

	public static GameObject fallThrough;

	public static RaycastHit lastHit;

	public static Vector2 lastTouchPosition;

	private static TouchState mController;

	private bool mIsEditor;

	private LayerMask mLayerMask;

	private static TouchState mMouse = new TouchState();

	private static float mNextEvent;

	public float mouseClickThreshold;

	private static GameObject mFocus;

	private static List<MyGUIInput> mList = new List<MyGUIInput>();

	private Dictionary<int, TouchState> mTouches = new Dictionary<int, TouchState>();

	public float touchClickThreshold;

	public bool useMouse;

	public bool useTouch;

	private Camera mCam;

	public static MyGUIInput eventHandler
	{
		get
		{
			for (int i = 0; i < mList.Count; i++)
			{
				MyGUIInput myGUIInput = mList[i];
				if (myGUIInput != null && myGUIInput.enabled && myGUIInput.gameObject.active)
				{
					return myGUIInput;
				}
			}
			return null;
		}
	}

	private bool handlesEvents
	{
		get
		{
			return eventHandler == this;
		}
	}

	public GameObject FocusedObject
	{
		get
		{
			return mFocus;
		}
		set
		{
			if (mFocus != value)
			{
				if (mFocus != null)
				{
					MyGUIEventListener.Get(mFocus).riseOnLostFocus(currentTouch.pressed);
				}
				mFocus = value;
				if (mFocus != null)
				{
					MyGUIEventListener.Get(mFocus).riseOnFocus();
				}
			}
		}
	}

	public Camera cachedCamera
	{
		get
		{
			if (mCam == null)
			{
				mCam = base.GetComponent<Camera>();
			}
			return mCam;
		}
	}

	private void Awake()
	{
		if (Application.platform == RuntimePlatform.Android || Application.platform == RuntimePlatform.IPhonePlayer)
		{
			useMouse = false;
			useTouch = true;
		}
		currentCamera = base.GetComponent<Camera>();
		if (currentCamera == null)
		{
		}
		mList.Add(this);
		mList.Sort(CompareFunc);
	}

	private static int CompareFunc(MyGUIInput a, MyGUIInput b)
	{
		if (a.cachedCamera.depth < b.cachedCamera.depth)
		{
			return 1;
		}
		if (a.cachedCamera.depth > b.cachedCamera.depth)
		{
			return -1;
		}
		return 0;
	}

	private bool Raycast(Vector3 inPos, ref RaycastHit hit)
	{
		for (int i = 0; i < mList.Count; i++)
		{
			MyGUIInput myGUIInput = mList[i];
			if (!myGUIInput.enabled || !myGUIInput.gameObject.active)
			{
				continue;
			}
			currentCamera = myGUIInput.cachedCamera;
			Vector3 vector = currentCamera.ScreenToViewportPoint(inPos);
			if (vector.x >= 0f && vector.x <= 1f && vector.y >= 0f && vector.y <= 1f)
			{
				Ray ray = currentCamera.ScreenPointToRay(inPos);
				int cullingMask = currentCamera.cullingMask;
				float distance = currentCamera.farClipPlane - currentCamera.nearClipPlane;
				if (Physics.Raycast(ray, out hit, distance, cullingMask))
				{
					return true;
				}
			}
		}
		return false;
	}

	private void ProcessMouse()
	{
		bool flag = Time.timeScale < 0.9f;
		if (!flag && (Input.GetMouseButton(0) || Input.GetMouseButtonUp(0)))
		{
			flag = true;
		}
		mMouse.pos = Input.mousePosition;
		Vector3 vector = currentCamera.ScreenToWorldPoint(Input.mousePosition);
		Vector3 vector2 = currentCamera.ScreenToWorldPoint(lastTouchPosition);
		mMouse.delta = vector - vector2;
		lastTouchPosition = mMouse.pos;
		if (flag)
		{
			mMouse.current = ((!Raycast(Input.mousePosition, ref lastHit)) ? fallThrough : lastHit.collider.gameObject);
		}
		bool mouseButtonDown = Input.GetMouseButtonDown(0);
		bool mouseButtonUp = Input.GetMouseButtonUp(0);
		currentTouch = mMouse;
		currentTouchID = -1;
		ProcessTouch(mouseButtonDown, mouseButtonUp);
		currentTouch = null;
	}

	private TouchState GetTouch(int id)
	{
		TouchState value;
		if (!mTouches.TryGetValue(id, out value))
		{
			value = new TouchState();
			mTouches.Add(id, value);
		}
		return value;
	}

	private void RemoveTouch(int id)
	{
		mTouches.Remove(id);
	}

	private void ProcessTouches()
	{
		for (int i = 0; i < Input.touchCount; i++)
		{
			Touch touch = Input.GetTouch(i);
			currentTouchID = touch.fingerId;
			currentTouch = GetTouch(currentTouchID);
			bool flag = touch.phase == TouchPhase.Began;
			bool flag2 = touch.phase == TouchPhase.Canceled || touch.phase == TouchPhase.Ended;
			if (flag)
			{
				currentTouch.delta = Vector2.zero;
			}
			else
			{
				Vector3 vector = currentCamera.ScreenToWorldPoint(touch.position);
				Vector3 vector2 = currentCamera.ScreenToWorldPoint(currentTouch.pos);
				currentTouch.delta = vector - vector2;
			}
			currentTouch.pos = touch.position;
			currentTouch.current = ((!Raycast(currentTouch.pos, ref lastHit)) ? fallThrough : lastHit.collider.gameObject);
			lastTouchPosition = currentTouch.pos;
			Debug.Log("pressed:" + flag + "released:" + flag2 + "currentTouch.current:" + currentTouch.current);
			ProcessTouch(flag, flag2);
			if (flag2)
			{
				RemoveTouch(currentTouchID);
			}
			currentTouch = null;
		}
	}

	private void ProcessTouch(bool pressed, bool released)
	{
		if (pressed)
		{
			currentTouch.pressed = currentTouch.current;
			currentTouch.clickNotification = ClickNotification.Always;
			currentTouch.totalDelta = Vector2.zero;
			if (currentTouch.pressed != null)
			{
				MyGUIEventListener.Get(currentTouch.pressed).riseOnPressed(currentTouch.pos);
				currentTouch.clickTime = Time.realtimeSinceStartup;
			}
			if (currentTouch.pressed != mFocus)
			{
				FocusedObject = null;
			}
		}
		else if (currentTouch.pressed != null && currentTouch.delta.magnitude != 0f)
		{
			MyGUIEventListener.Get(currentTouch.pressed).riseOnMoved(currentTouch.delta);
			currentTouch.totalDelta += currentTouch.delta;
			if (currentTouch.clickNotification == ClickNotification.BasedOnDelta)
			{
				float num = ((currentTouch != mMouse) ? Mathf.Max(touchClickThreshold, (float)Screen.height * 0.1f) : mouseClickThreshold);
				if (currentTouch.totalDelta.magnitude > num)
				{
					currentTouch.clickNotification = ClickNotification.None;
				}
			}
		}
		if (!released)
		{
			return;
		}
		if (currentTouch.pressed != null)
		{
			MyGUIEventListener myGUIEventListener = MyGUIEventListener.Get(currentTouch.pressed);
			myGUIEventListener.riseOnReleased(currentTouch.pos);
			if (currentTouch.pressed == currentTouch.current)
			{
				if (currentTouch.pressed != mFocus)
				{
					FocusedObject = currentTouch.pressed;
				}
				if (currentTouch.clickNotification != 0)
				{
					myGUIEventListener.riseOnClicked();
				}
			}
			else if (currentTouch.current != null)
			{
				MyGUIEventListener.Get(currentTouch.current).riseOnDropped(currentTouch.pressed);
			}
		}
		currentTouch.pressed = null;
	}

	private void Update()
	{
		if (Application.isPlaying && handlesEvents)
		{
			if (useMouse)
			{
				ProcessMouse();
			}
			if (useTouch)
			{
				ProcessTouches();
			}
		}
	}

	private void OnDestroy()
	{
		mList.Remove(this);
	}
}
