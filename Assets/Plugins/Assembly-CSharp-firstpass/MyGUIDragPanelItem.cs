using UnityEngine;

public class MyGUIDragPanelItem : MonoBehaviour
{
	private Transform mTrans;

	public MyGUIDragablePanel draggablePanel;

	private void Awake()
	{
		mTrans = base.transform;
	}

	private void Start()
	{
		draggablePanel = base.transform.parent.GetComponent<MyGUIDragablePanel>();
		if (draggablePanel == null)
		{
			draggablePanel = base.transform.parent.gameObject.AddComponent<MyGUIDragablePanel>();
		}
		MyGUIEventListener.Get(base.gameObject).EventHandleOnPressed += OnPress;
		MyGUIEventListener.Get(base.gameObject).EventHandleOnReleased += OnRelease;
		MyGUIEventListener.Get(base.gameObject).EventHandleOnMoved += OnMoved;
	}

	private void OnMoved(GameObject go, Vector2 delta)
	{
		if (draggablePanel != null)
		{
			draggablePanel.Drag(delta);
		}
	}

	private void OnPress(GameObject go, Vector2 vec2)
	{
		if (base.enabled && base.gameObject.active && draggablePanel != null)
		{
			draggablePanel.Press();
		}
	}

	private void OnRelease(GameObject go, Vector2 vec2)
	{
		if (base.enabled && base.gameObject.active && draggablePanel != null)
		{
			draggablePanel.Release(vec2);
		}
	}
}
