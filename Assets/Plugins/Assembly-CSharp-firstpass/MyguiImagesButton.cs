using UnityEngine;

public class MyguiImagesButton : MyguiButton
{
	public MyguiSpriteAnimation spriteAnimition;

	private void Awake()
	{
		if (spriteAnimition == null)
		{
			sprite = GetComponentInChildren<TUIMeshSprite>();
		}
	}

	protected override void onPressed(GameObject go, Vector2 pos)
	{
		spriteAnimition.enabled = false;
		sprite.frameName = pressedSprite;
		sprite.UpdateMesh();
		m_IsPressed = true;
	}

	protected override void onReleased(GameObject go, Vector2 pos)
	{
		spriteAnimition.enabled = true;
		m_IsPressed = false;
	}
}
