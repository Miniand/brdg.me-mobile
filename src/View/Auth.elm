module View.Auth where

import StartApp
import Html
import Html.Attributes
import Html.Events
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
    [ Html.Events.onWithOptions
      "submit"
      { stopPropagation = False, preventDefault = True }
      Json.Decode.value
      (\_ -> Signal.message address Submit)
    ]
    [ Html.div []
      [ Html.input
        [ Html.Attributes.class "mdl-textfield__input"
        , Html.Attributes.placeholder "Email address"
        , Html.Attributes.value model.email
        , Html.Attributes.disabled model.sending
        , Html.Events.on
          "input"
          Html.Events.targetValue
          (\str -> Signal.message address (UpdateEmail str))
        ]
        []
      ]
    , Html.div []
      [ Html.input
        [ Html.Attributes.class "mdl-textfield__input"
        , Html.Attributes.placeholder "Code"
        , Html.Attributes.value model.confirmation
        , Html.Attributes.disabled model.sending
        , Html.Events.on
          "input"
          Html.Events.targetValue
          (\str -> Signal.message address (UpdateConfirmation str))
        ]
        []
      ]
    , Html.div []
      (if model.sending then [ Html.text "sending" ] else [])
    , Html.div []
      [ Html.button
        [ Html.Attributes.type' "submit"
        , Html.Attributes.class "mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--colored"
        , Html.Attributes.disabled model.sending
        ]
        [ Html.text "Log in" ]
      ]
    ]
