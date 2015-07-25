import Html
import Html.Attributes
import Router exposing (..)
import History

main : Signal Html.Html
main = Signal.map route History.hash

route : Route Html.Html
route = match
  [ ""      :-> displayHome
  , "#games" :-> displayGames
  ] display404

displayHome = always (Html.div []
  [ Html.div [] [ Html.text "Home page" ]
  , Html.div []
    [ Html.a [ Html.Attributes.href "#games" ] [ Html.text "Games" ]
    ]
  ])
displayGames = always (Html.div []
  [ Html.div [] [ Html.text "Games" ]
  , Html.div []
    [ Html.a [ Html.Attributes.href "#" ] [ Html.text "Home" ]
    ]
  ])
display404 = always (Html.text "Page not found")
