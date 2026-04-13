using UnityEngine;

public class MyguiButton : MonoBehaviour
{
	public bool Enabled = true;

	public TUIMeshSprite sprite;

	public string normalSprite;

	public string disabledSprite;

	public string pressedSprite;

	public bool m_IsPressed;

	public bool m_bModeImage = true;

	public bool mEnbledScale;

	private void Awake()
	{
		if (sprite == null)
		{
			sprite = GetComponentInChildren<TUIMeshSprite>();
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
		sprite.frameName = pressedSprite;
		sprite.UpdateMesh();
		m_IsPressed = true;
	}

	protected virtual void onReleased(GameObject go, Vector2 pos)
	{
		sprite.frameName = normalSprite;
		sprite.UpdateMesh();
		m_IsPressed = false;
	}
}
