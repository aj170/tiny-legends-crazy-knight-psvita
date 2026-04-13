using UnityEngine;

public class MyGUIImageButton : MonoBehaviour
{
	public bool m_disabled;

	public TUIMeshSprite sprite;

	public string normalSprite;

	public string disabledSprite;

	public string disabledPressSprite;

	public string pressedSprite;

	public bool disabled
	{
		get
		{
			return m_disabled;
		}
		set
		{
			if (m_disabled != value)
			{
				m_disabled = value;
				if (sprite == null)
				{
					Debug.LogError("sdfsdfsddddddddddddddddddddddd");
				}
				if (m_disabled)
				{
					sprite.frameName = disabledSprite;
					sprite.UpdateMesh();
				}
				else
				{
					sprite.frameName = normalSprite;
					sprite.UpdateMesh();
				}
			}
		}
	}

	private void Awake()
	{
		if (sprite == null)
		{
			sprite = GetComponentInChildren<TUIMeshSprite>();
		}
		if (sprite == null)
		{
			Debug.LogError("sdfsdfsddddddddddddddddddddddd");
		}
	}

	private void Start()
	{
		MyGUIEventListener myGUIEventListener = MyGUIEventListener.Get(base.gameObject);
		myGUIEventListener.EventHandleOnPressed += onPressed;
		myGUIEventListener.EventHandleOnReleased += onReleased;
	}

	protected virtual void onPressed(GameObject go, Vector2 pos)
	{
		if (disabled)
		{
			sprite.frameName = disabledPressSprite;
			sprite.UpdateMesh();
		}
		else
		{
			sprite.frameName = pressedSprite;
			sprite.UpdateMesh();
		}
	}

	protected virtual void onReleased(GameObject go, Vector2 pos)
	{
		if (disabled)
		{
			sprite.frameName = disabledSprite;
			sprite.UpdateMesh();
		}
		else
		{
			sprite.frameName = normalSprite;
			sprite.UpdateMesh();
		}
	}
}
