module View.Auth where

import StartApp
import Html
import Html.Attributes as Attr
import Html.Events as Evt
import Json.Decode

main : Signal Html.Html
main = StartApp.start { model = init, view = view, update = update }

type alias Model =
  { email : String
  , confirmation : String
  , sending : Bool
  }

init : Model
init =
  { email = ""
  , confirmation = ""
  , sending = False
  }

type Action
  = Submit
  | UpdateEmail String
  | UpdateConfirmation String

update : Action -> Model -> Model
update action model =
  case action of
    Submit ->
      { model |
        sending <- True
      }
    UpdateEmail newEmail ->
      { model |
        email <- newEmail
      }
    UpdateConfirmation newConfirmation ->
      { model |
        confirmation <- newConfirmation
      }

view : Signal.Address Action -> Model -> Html.Html
view address model =
  Html.form 
    [ Evt.onWithOptions
      "submit"
      { stopPropagation = False, preventDefault = True }
      Json.Decode.value
      (\_ -> Signal.message address Submit)
    ]
    [ Html.div []
      [ Html.input
        [ Attr.placeholder "Email address"
        , Attr.value model.email
        , Attr.disabled model.sending
        , Evt.on
          "input"
          Evt.targetValue
          (\str -> Signal.message address (UpdateEmail str))
        ]
        []
      ]
    , Html.div []
      [ Html.input
        [ Attr.placeholder "Code"
        , Attr.value model.confirmation
        , Attr.disabled model.sending
        , Evt.on
          "input"
          Evt.targetValue
          (\str -> Signal.message address (UpdateConfirmation str))
        ]
        []
      ]
    , Html.div []
      (if model.sending then [ Html.text "sending" ] else [])
    , Html.div []
      [ Html.button
        [ Attr.type' "submit"
        , Attr.disabled model.sending
        ]
        [ Html.text (if model.confirmation == "" then "Log in" else "Confirm") ]
      ]
    ]
