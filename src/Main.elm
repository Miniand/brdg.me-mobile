import Html
import Router exposing (..)
import History

import View.Auth
import View.Home
import View.Games

main : Signal Html.Html
main = Signal.map route History.hash

route : Route Html.Html
route = match
  [ ""       :-> View.Home.display
  , "#auth"  :-> View.Auth.display
  , "#games" :-> View.Games.display
  ] display404

display404 = always (Html.text "Page not found")
