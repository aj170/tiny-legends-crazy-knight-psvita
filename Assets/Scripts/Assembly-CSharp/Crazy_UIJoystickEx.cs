using UnityEngine;

public class Crazy_UIJoystickEx : Crazy_UIJoystick
{
	public GameObject frame_d;

	public bool pressed;

    private Vector2 keyboardInput = Vector2.zero;

    public new void Start()
	{
		base.Start();
		UpdateFrame();
	}

    // ==================== MAIN UPDATE - ADDED KEYBOARD SUPPORT ====================
    private void Update()
    {
        Vector2 input = Vector2.zero;

        // 1. Keyboard input (WASD + Arrow Keys)
        if (Input.GetKey(KeyCode.W) || Input.GetKey(KeyCode.UpArrow))
            input.y += 1f;
        if (Input.GetKey(KeyCode.S) || Input.GetKey(KeyCode.DownArrow))
            input.y -= 1f;
        if (Input.GetKey(KeyCode.A) || Input.GetKey(KeyCode.LeftArrow))
            input.x -= 1f;
        if (Input.GetKey(KeyCode.D) || Input.GetKey(KeyCode.RightArrow))
            input.x += 1f;

        // 2. PS Vita / Controller Left Analog Stick (only when building for Vita)

    float h = Input.GetAxis("Left Joystick Horizontal");
    float v = Input.GetAxis("Left Joystick Vertical");
    Vector2 vitaInput = new Vector2(h, v);

    // Use Vita stick if it's being moved (gives it priority)
    if (vitaInput.sqrMagnitude > 0.1f)
    {
        input = vitaInput;
    }


        // Normalize input (prevents faster diagonal movement)
        if (input.sqrMagnitude > 0.001f)
        {
            input.Normalize();
        }

        // === APPLY INPUT TO VIRTUAL JOYSTICK ===
        if (input.sqrMagnitude > 0.001f)
        {
            if (!pressed)
            {
                pressed = true;
                UpdateFrame();
            }

            // Simulate joystick movement
            Vector2 simulatedPos = new Vector2(base.transform.position.x, base.transform.position.y)
                                 + input * max;

            DoMove(simulatedPos);
            PostEvent(this, 2, input.x, input.y, null);
        }
        // Reset when no input (and no touch active)
        else if (pressed && fingerId == -1)
        {
            pressed = false;
            UpdateFrame();
            DoReset();
            PostEvent(this, 3, 0f, 0f, null);
        }

        // ==================== KEYBOARD / CONTROLLER BUTTONS ====================
        // Attack / Fight
        if (Input.GetButtonDown("Attack") || Input.GetKeyDown(KeyCode.Space))
        {
            if (Crazy_PlayerControl.player != null)
            {
                Crazy_PlayerControl.player.GetComponent<Crazy_PlayerControl>().PlayerAttack();
            }
        }

        // Roll
        if (Input.GetButtonDown("Roll"))
        {
            if (Crazy_PlayerControl.player != null)
            {
                Crazy_PlayerControl.player.GetComponent<Crazy_PlayerControl>().PlayerRoll();
            }
        }

        // Skill
        if (Input.GetButtonDown("Skill"))
        {
            if (Crazy_PlayerControl.player != null)
            {
                Crazy_PlayerControl.player.GetComponent<Crazy_PlayerControl>().PlayerSkill();
            }
        }
        
    }

    protected void UpdateFrame()
	{
		HideFrame();
		ShowFrame();
	}

	private void HideFrame()
	{
		if ((bool)frame)
		{
			frame.active = false;
		}
		if ((bool)frame_d)
		{
			frame_d.active = false;
		}
	}

	private void ShowFrame()
	{
		if (pressed)
		{
			if ((bool)frame_d)
			{
				frame_d.active = true;
			}
		}
		else if ((bool)frame)
		{
			frame.active = true;
		}
	}

	public override bool HandleInput(TUIInput input)
	{
		if (input.inputType == TUIInputType.Began)
		{
			if (PtInControl(input.position))
			{
				fingerId = input.fingerId;
				DoReset();
				PostEvent(this, 1, 0f, 0f, null);
				Vector2 vector = DoMove(input.position);
				PostEvent(this, 2, vector.x, vector.y, null);
				pressed = true;
				UpdateFrame();
				return true;
			}
			return false;
		}
		if (input.fingerId != fingerId)
		{
			return false;
		}
		if (input.inputType == TUIInputType.Moved)
		{
			Vector2 vector2 = DoMove(input.position);
			PostEvent(this, 2, vector2.x, vector2.y, null);
			return true;
		}
		if (input.inputType == TUIInputType.Ended)
		{
			fingerId = -1;
			DoReset();
			PostEvent(this, 3, 0f, 0f, null);
			pressed = false;
			UpdateFrame();
			return true;
		}
		return false;
	}

	private void DoReset()
	{
		frame.transform.position = new Vector3(base.transform.position.x, base.transform.position.y, frame.transform.position.z);
		frame_d.transform.position = new Vector3(base.transform.position.x, base.transform.position.y, frame_d.transform.position.z);
	}

	private Vector2 DoMove(Vector2 position)
	{
		Vector2 vector = new Vector2(base.transform.position.x, base.transform.position.y);
		Vector2 vector2 = position - vector;
		float magnitude = vector2.magnitude;
		float value = (magnitude - min) / (max - min);
		value = Mathf.Clamp(value, 0f, 1f);
		Vector2 vector3 = value * vector2.normalized;
		Vector2 vector4 = vector + vector3 * max;
		frame.transform.position = new Vector3(vector4.x, vector4.y, frame.transform.position.z);
		frame_d.transform.position = new Vector3(vector4.x, vector4.y, frame_d.transform.position.z);
		return vector3;
	}

	public void Reset()
	{
		fingerId = -1;
		DoReset();
		PostEvent(this, 3, 0f, 0f, null);
		pressed = false;
		UpdateFrame();
	}
}
