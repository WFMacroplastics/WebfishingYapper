using GDWeave.Godot;
using GDWeave.Godot.Variants;
using GDWeave.Modding;

namespace Yapper;

public class ChatPatch : IScriptMod
{
    public bool ShouldRun(string path) => path == "res://Scenes/Singletons/SteamNetwork.gdc";

    public IEnumerable<Token> Modify(string path, IEnumerable<Token> tokens)
    {
        // wait for any newline after any reference to "_update_chat"
        var waiter = new MultiTokenWaiter([
            t => t is IdentifierToken { Name: "_update_chat" },
            t => t.Type is TokenType.Newline
        ], allowPartialMatch: true);

        foreach (var token in tokens)
        {
            if (waiter.Check(token))
            {
                yield return token;

                // if $"/root/Yapper": $"/root/Yapper"._queue("chat", text)
                yield return new Token(TokenType.CfIf);
                yield return new Token(TokenType.Dollar);
                yield return new ConstantToken(new StringVariant("/root/Yapper"));
                yield return new Token(TokenType.Colon);
                yield return new Token(TokenType.Dollar);
                yield return new ConstantToken(new StringVariant("/root/Yapper"));
                yield return new Token(TokenType.Period);
                yield return new IdentifierToken("_queue");
                yield return new Token(TokenType.ParenthesisOpen);
                yield return new ConstantToken(new StringVariant("chat"));
                yield return new Token(TokenType.Comma);
                yield return new IdentifierToken("text");
                yield return new Token(TokenType.ParenthesisClose);

                yield return token;
            }
            else
            {
                yield return token;
            }
        }
    }

}