using GDWeave;

namespace Yapper;

public class Mod : IMod {
    public static Config Config = null!;

    public Mod(IModInterface modInterface) {
        Config = modInterface.ReadConfig<Config>();
        modInterface.RegisterScriptMod(new ResolveAssemblyPath());
        modInterface.RegisterScriptMod(new TooltipPatch());
        modInterface.RegisterScriptMod(new DialoguePatch());
        modInterface.RegisterScriptMod(new ConfigPatch());
        modInterface.RegisterScriptMod(new ChatPatch());
	}

    public void Dispose() {
        // Cleanup anything you do here
    }
}