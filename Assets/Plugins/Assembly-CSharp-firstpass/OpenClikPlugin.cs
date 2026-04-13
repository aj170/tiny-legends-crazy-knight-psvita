public class OpenClikPlugin
{
	private enum Status
	{
		kShowFull = 0,
		kShowTip = 1,
		kHide = 2
	}

	private static Status s_Status;

	public static void Initialize(string key)
	{
		s_Status = Status.kHide;
	}

	public static void Show(bool show_full)
	{
		if (s_Status == Status.kHide)
		{
			if (show_full)
			{
				s_Status = Status.kShowFull;
			}
			else
			{
				s_Status = Status.kShowTip;
			}
		}
		else if (s_Status == Status.kShowFull)
		{
			if (!show_full)
			{
				s_Status = Status.kShowTip;
			}
		}
		else if (s_Status == Status.kShowTip && show_full)
		{
			s_Status = Status.kShowFull;
		}
	}

	public static void Hide()
	{
		s_Status = Status.kHide;
	}
}
