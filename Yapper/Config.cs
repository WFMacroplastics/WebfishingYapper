using System.Text.Json.Serialization;

namespace Yapper;

public class Config
{
    [JsonInclude] public int VoiceSpeed = 0;
}
