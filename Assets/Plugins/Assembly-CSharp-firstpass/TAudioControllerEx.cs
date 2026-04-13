public class TAudioControllerEx : TAudioController
{
	private string musicName = string.Empty;

	public void PlayMusic(string objName)
	{
		if (!(musicName == objName))
		{
			PlayAudio(objName);
			if (musicName != string.Empty)
			{
				StopAudio(musicName);
			}
			musicName = objName;
		}
	}

	public void StopAllMusic()
	{
		StopAudio(musicName);
	}
}
