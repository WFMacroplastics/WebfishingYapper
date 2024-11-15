using GDWeave.Godot;
using GDWeave.Godot.Variants;
using GDWeave.Modding;

namespace Yapper;

public class ConfigPatch : IScriptMod
{
    public bool ShouldRun(string path) => path == "res://mods/Yapper/main.gdc";

    public IEnumerable<Token> Modify(string path, IEnumerable<Token> tokens)
    {
        // wait for any newline after any reference to "_ready"
        var waiter = new MultiTokenWaiter([
            t => t is IdentifierToken { Name: "_ready" },
            t => t.Type is TokenType.Newline
        ], allowPartialMatch: true);

        // loop through all tokens in the script
        foreach (var token in tokens)
        {
            if (waiter.Check(token))
            {
                // found our match, return the original newline
                yield return token;

                // then add our own code
                yield return new IdentifierToken("_init_voice_config");
                yield return new Token(TokenType.ParenthesisOpen);
                yield return new ConstantToken(new IntVariant(Mod.Config.VoiceSpeed));
                yield return new Token(TokenType.ParenthesisClose);

                // don't forget another newline!
                yield return token;
            }
            else
            {
                // return the original token
                yield return token;
            }
        }
    }
}