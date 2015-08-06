import Html
import Router exposing (..)
import History
import StartApp

import View.Auth
import View.Home
import View.Games

type alias Model =
  { auth : View.Auth.Model
  , path : String
  }

type Action
  = SetPath String
  | AuthAction View.Auth.Action
  | NoOp

update : Action -> Model -> Model
update action model =
  case action of
    SetPath path ->
      { model | path <- path }
    AuthAction authAction ->
      { model | auth <- View.Auth.update authAction model.auth }
    NoOp ->
      model

view : Signal.Address Action -> Model -> Html.Html
view address model =
  let
    authAddress = Signal.forwardTo address AuthAction
    display404 _ = Html.text "Page not found"
    viewPage = match
      [ "#auth" :-> always (View.Auth.view authAddress model.auth)
      ] display404
  in
    viewPage model.path

setPaths : Signal Action
setPaths = Signal.map SetPath History.hash

appMailbox : Signal.Mailbox Action
appMailbox = Signal.mailbox NoOp

actions = Signal.merge setPaths appMailbox.signal

init : Model
init =
  { auth = View.Auth.init
  , path = ""
  }

main =
  Signal.map (view appMailbox.address)
    (Signal.foldp update init actions)
