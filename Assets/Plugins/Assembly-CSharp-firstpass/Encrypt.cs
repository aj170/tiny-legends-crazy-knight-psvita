public class Encrypt
{
	public static string Encode(string input)
	{
		return XXTEAUtils.Encrypt(input, "1");
	}

	public static string Decode(string input)
	{
		return XXTEAUtils.Decrypt(input, "1");
	}
}
