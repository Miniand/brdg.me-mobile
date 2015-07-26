module View.Games where

import Html
import Html.Attributes

display = always (Html.div []
  [ Html.div [] [ Html.text "Games" ]
  , Html.div []
    [ Html.a [ Html.Attributes.href "#" ] [ Html.text "Home" ]
    ]
  ])
