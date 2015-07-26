import Html
import Router exposing (..)
import History
import StartApp

import View.Auth
import View.Home
import View.Games

main : Signal Html.Html
main = Signal.map route History.hash

actions = Signal.mailbox Nothing
address = Signal.forwardTo actions.address Just

route : Route Html.Html
route = match
  [ ""       :-> View.Home.display
  , "#auth"  :-> \url -> View.Auth.view address View.Auth.init
  , "#games" :-> View.Games.display
  ] display404

display404 = always (Html.text "Page not found")
