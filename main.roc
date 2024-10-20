app [main] { 
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.15.0/SlwdbJ-3GR7uBWQo6zlmYWNYOxnvo8r6YABXD-45UOw.tar.br" ,
}

import pf.Stdout
import pf.Stdin
import pf.Utc
import pf.Arg

Game : { number: I32 }

parseGuess : Str -> Result I32 [InvalidNumStr] 
parseGuess = \guess -> Str.toI32 guess

handleGuess = \number, game -> 
    if number == game.number then
        Stdout.line! "You got it!"
        Task.ok (Done {})
    else if number < game.number then 
        Stdout.line! "Go bigger!"
        Task.ok (Step game)
    else
        Stdout.line! "Go smaller!"
        Task.ok (Step game)

handleInput = \game, text -> 
    parsedText = Str.toI32 text
    when parsedText is 
        Ok num -> handleGuess num game
        Err _ -> 
            Stdout.line! "Alas, that's not a number!"
            Task.ok (Step game)

runPrompt = \game -> 
    Stdout.line! "What's your guess?"
    Task.attempt Stdin.line \input -> 
        when input is 
            Ok text -> handleInput game text
            Err _ -> 
                Stdout.line! "Woe! Something's gone wrong."
                Task.ok (Done {}) 

main =
    args = (Arg.list {})! 
    defaultNumber = 63
    number = 
        args
            |> List.get 1
            |> Result.try (\s -> Str.toI32 s)
            |> Result.withDefault defaultNumber

    game = { number }

    Stdout.line! "Welcome to number guesser, the game where you have to guess a number!"
    Task.loop game runPrompt











    
    



    