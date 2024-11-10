using GDWeave.Godot;
using GDWeave.Godot.Variants;
using GDWeave.Modding;

namespace Yapper;

public class TooltipPatch : IScriptMod
{
    public bool ShouldRun(string path) => path == "res://Scenes/Singletons/Tooltips/tooltip.gdc";

    public IEnumerable<Token> Modify(string path, IEnumerable<Token> tokens)
    {
        // if hovered_tooltip == node:
        var tooltipExitMatch = new MultiTokenWaiter([
            t => t.Type is TokenType.CfIf,
            t => t is IdentifierToken { Name: "hovered_tooltip" },
            t => t.Type is TokenType.OpEqual,
            t => t is IdentifierToken { Name: "node" },
            t => t.Type is TokenType.Colon,
            t => t.Type is TokenType.Newline
        ]);

        var tooltipEnterMatch = new MultiTokenWaiter([
            t => t is IdentifierToken {Name: "_update_visible"},
            t => t.Type is TokenType.ParenthesisOpen,
            t => t.Type is TokenType.ParenthesisClose,
            t => t.Type is TokenType.Colon,
            t => t.Type is TokenType.Newline
        ]);
        foreach (var token in tokens)
        {
            if (tooltipExitMatch.Check(token))
            {
                yield return token;

                // if $"/root/Yapper": $"/root/Yapper"._dequeue_tooltip()
                yield return new Token(TokenType.CfIf);
                yield return new Token(TokenType.Dollar);
                yield return new ConstantToken(new StringVariant("/root/Yapper"));
                yield return new Token(TokenType.Colon);
                yield return new Token(TokenType.Dollar);
                yield return new ConstantToken(new StringVariant("/root/Yapper"));
                yield return new Token(TokenType.Period);
                yield return new IdentifierToken("_dequeue_tooltip");
                yield return new Token(TokenType.ParenthesisOpen);
                yield return new Token(TokenType.ParenthesisClose);
                yield return new Token(TokenType.Newline, 2);

                yield return token;
            } else if (tooltipEnterMatch.Check(token))
            {
                yield return token;

                // if $"/root/Yapper": $"/root/Yapper"._queue_tooltip(current_header, current_body)
                yield return new Token(TokenType.CfIf);
                yield return new Token(TokenType.Dollar);
                yield return new ConstantToken(new StringVariant("/root/Yapper"));
                yield return new Token(TokenType.Colon);
                yield return new Token(TokenType.Dollar);
                yield return new ConstantToken(new StringVariant("/root/Yapper"));
                yield return new Token(TokenType.Period);
                yield return new IdentifierToken("_queue_tooltip");
                yield return new Token(TokenType.ParenthesisOpen);
                yield return new IdentifierToken("current_header");
                yield return new Token(TokenType.Comma);
                yield return new IdentifierToken("current_body");
                yield return new Token(TokenType.ParenthesisClose);
                yield return new Token(TokenType.Newline, 1);

                yield return token;
            }
            else
            {
                yield return token;
            }
        }
    }

}