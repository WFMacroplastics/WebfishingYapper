using GDWeave.Godot;
using GDWeave.Godot.Variants;
using GDWeave.Modding;

namespace Yapper;

public class DialoguePatch : IScriptMod
{
    public bool ShouldRun(string path) => path == "res://Scenes/HUD/dialogue.gdc";

    public IEnumerable<Token> Modify(string path, IEnumerable<Token> tokens)
    {
        // bank[i]
        var dialogueMatch = new MultiTokenWaiter([
            t => t is IdentifierToken {Name: "bank"},
            t => t.Type is TokenType.BracketOpen,
            t => t is IdentifierToken {Name: "i"},
            t => t.Type is TokenType.BracketClose,
            t => t.Type is TokenType.Newline
        ]);
        foreach (var token in tokens)
        {
            if (dialogueMatch.Check(token))
            {
                yield return new Token(TokenType.Newline, 1); 
                // if $"/root/Yapper": $"/root/Yapper"._queue("dialogue", bank[i])
                yield return new Token(TokenType.CfIf);
                yield return new Token(TokenType.Dollar);
                yield return new ConstantToken(new StringVariant("/root/Yapper"));
                yield return new Token(TokenType.Colon);
                yield return new Token(TokenType.Dollar);
                yield return new ConstantToken(new StringVariant("/root/Yapper"));
                yield return new Token(TokenType.Period);
                yield return new IdentifierToken("_queue");
                yield return new Token(TokenType.ParenthesisOpen);
                yield return new ConstantToken(new StringVariant("dialogue"));
                yield return new Token(TokenType.Comma);
                yield return new IdentifierToken("bank");
                yield return new Token(TokenType.BracketOpen);
                yield return new IdentifierToken("i");
                yield return new Token(TokenType.BracketClose);
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