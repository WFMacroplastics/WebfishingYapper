using GDWeave;

namespace Yapper;

public class Mod : IMod {
    public Mod(IModInterface modInterface) {
        modInterface.RegisterScriptMod(new ResolveAssemblyPath());
        modInterface.RegisterScriptMod(new TooltipPatch());
        modInterface.RegisterScriptMod(new DialoguePatch());
        modInterface.RegisterScriptMod(new ChatPatch());
	}

    public void Dispose() {
        // Cleanup anything you do here
    }
}