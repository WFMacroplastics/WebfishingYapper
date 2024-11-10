using System.Reflection;
using GDWeave.Godot;
using GDWeave.Godot.Variants;
using GDWeave.Modding;

namespace Yapper;

// Thanks Jules:
// https://github.com/NotNite/WebfishingRichPresence/blob/main/WebfishingRichPresence/LibRPCFetcher.cs
public class ResolveAssemblyPath : IScriptMod {
    public bool ShouldRun(string path) => path == "res://mods/Yapper/tts.gdc";

    public IEnumerable<Token> Modify(string path, IEnumerable<Token> tokens) {
        foreach (var token in tokens) {
            if (token is ConstantToken {Value: StringVariant {Value: "%LIBGDTTS%"} str}) {
                str.Value = Path.Combine(
                    Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location)!,
                    "libgdtts.windows.x86_64.dll"
                );
            }

            yield return token;
        }
    }
}