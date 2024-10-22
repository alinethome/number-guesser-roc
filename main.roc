app [main] { 
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.15.0/SlwdbJ-3GR7uBWQo6zlmYWNYOxnvo8r6YABXD-45UOw.tar.br" ,
    rand: "https://github.com/lukewilliamboswell/roc-random/releases/download/0.3.0/hPlOciYUhWMU7BefqNzL89g84-30fTE6l2_6Y3cxIcE.tar.br",
}

import pf.Stdout
import pf.Stdin
import pf.Utc
import pf.Arg
import rand.Random

Game : { number: U8 }

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
    parsedText = Str.toU8 text
    when parsedText is 
        Ok seedNum -> handleGuess seedNum game
        Err _ -> 
            Stdout.line! "Alas, that's not a valid number!"
            Stdout.line! "Numbers should be betwewen 0 and 255"
            Task.ok (Step game)

runPrompt = \game -> 
    Stdout.line! "What's your guess?"
    Task.attempt Stdin.line \input -> 
        when input is 
            Ok text -> handleInput game text
            Err _ -> 
                Stdout.line! "Woe! Something's gone wrong."
                Task.ok (Done {}) 

generateDefaultNumber : U32 -> U8
generateDefaultNumber = \num -> 
    initialSeed = Random.seed num
    generator =  Random.u8 
    random = generator initialSeed
    random.value


generateNumber : U8 -> Task U8 _
generateNumber = \defaultNumber -> 
    args = (Arg.list {})!
    args
        |> List.get 1
        |> Result.try (\s -> Str.toU8 s)
        |> Result.withDefault defaultNumber
        |> Task.ok

generateSeedNum : {} -> Task U32 _
generateSeedNum = \_ ->
    (Utc.now {})!
    |> Utc.toMillisSinceEpoch 
    |> Num.toU32
    |> Task.ok

    

main =
    seedNum = (generateSeedNum {})!
    Stdout.line! (Num.toStr seedNum)

    defaultNumber = generateDefaultNumber seedNum
    number = generateNumber! defaultNumber

    game : Game
    game = { number }

    Stdout.line! "Welcome to number guesser, the game where you have to guess a number!"
    Task.loop game runPrompt











    
    



    