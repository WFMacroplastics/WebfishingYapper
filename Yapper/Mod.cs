using GDWeave;

namespace Yapper;

public class Mod : IMod {
    public Config Config;

    public Mod(IModInterface modInterface) {
        this.Config = modInterface.ReadConfig<Config>();
        modInterface.RegisterScriptMod(new ResolveAssemblyPath());
	}

    public void Dispose() {
        // Cleanup anything you do here
    }
}