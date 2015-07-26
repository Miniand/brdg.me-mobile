module View.Home where

import Html
import Html.Attributes

display = always (Html.div []
  [ Html.div [] [ Html.text "Home" ]
  , Html.div []
    [ Html.a [ Html.Attributes.href "#games" ] [ Html.text "Games" ]
    ]
  ])
