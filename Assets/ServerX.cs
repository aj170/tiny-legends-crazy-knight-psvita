public static class ServerX
{
    public const string configUrl = "recompilation.net/game/tnet-config-1.txt";

    const string gameId = "tlck";

    public static bool Parse(string text, ref string ip, ref int port)
    {
        int portParse;

        string[] entries = text.Split('\n');

        foreach (string entry in entries)
        {
            string[] entriesItem = entry.Split(' ');

            if (entriesItem.Length < 3) continue;

            if (entriesItem[0] != gameId) continue;

            if (!int.TryParse(entriesItem[2], out portParse)) continue;

            ip = entriesItem[1];
            port = portParse;

            return true;
        }
        return false;
    }
}
