module View.Game where

import StartApp
import Html
import Html.Attributes as Attr
import Html.Events as Evt
import Http
import Json.Decode as Json
import Effects exposing (Effects, Never)
import Task

app : StartApp.App Model
app = StartApp.start
  { init = init "db58f243-22c9-4ab9-88bd-dbe470d127ed" "1XcXMtsoQ5iByodFC2FmmKVFvwKEbVEP"
  , view = view
  , update = update
  , inputs = []
  }

port tasks : Signal (Task.Task Never ())
port tasks = app.tasks

main : Signal Html.Html
main = app.html

type alias Model =
  { gameId : String
  , game : String
  , log : String
  , token : String
  , command : String
  }

init : String -> String -> (Model, Effects Action)
init gameId token =
  ( { gameId = gameId
    , game = ""
    , log = ""
    , token = token
    , command = ""
    }
  , fetchGame gameId token
  )

type Action
  = Play
  | UpdateCommand String
  | FetchedGame (Maybe String)
  | NoOp

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Play ->
      ( model
      , Effects.none
      )
    UpdateCommand newCommand ->
      ( { model
        | command <- newCommand
        }
      , Effects.none
      )
    FetchedGame (Just game) ->
      ( { model
        | game <- game
        }
      , Effects.none
      )
    NoOp ->
      ( model
      , Effects.none
      )

view : Signal.Address Action -> Model -> Html.Html
view address model =
  Html.div []
    [ Html.form 
      [ Evt.onWithOptions
        "submit"
        { stopPropagation = False, preventDefault = True }
        Json.value
        (\_ -> Signal.message address Play)
      ]
      [ Html.div []
        [ Html.input
          [ Attr.placeholder "Enter command"
          , Attr.value model.command
          , Evt.on
            "input"
            Evt.targetValue
            (\str -> Signal.message address (UpdateCommand str))
          ]
          []
        , Html.button
          [ Attr.type' "submit" ]
          [ Html.text "Send" ]
        ]
      ]
    
    , Html.text (if model.game == "" then "Loading..." else model.game)
    ]

gameRequest : String -> String -> Http.Request
gameRequest gameId token =
  { verb = "GET"
  , headers = [ ( "Authorization", "token " ++ token ) ]
  , url = "https://api.brdg.me/game/" ++ gameId
  , body = Http.empty
  }

fetchGame : String -> String -> Effects Action
fetchGame gameId token =
  Http.fromJson decodeGame (Http.send Http.defaultSettings (gameRequest gameId token))
    |> Task.toMaybe
    |> Task.map FetchedGame
    |> Effects.task

decodeGame : Json.Decoder String
decodeGame = Json.at ["game"] Json.string
