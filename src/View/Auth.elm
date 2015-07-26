module View.Auth where

import StartApp
import Html
import Html.Attributes

main = StartApp.start { model = "", view = view, update = update }

update newStr oldStr = newStr

view : Signal.Address String -> String -> Html.Html
view address string =
  Html.form []
    [ Html.div [] [ Html.input
      [ Html.Attributes.placeholder "Email address"
      , Html.Attributes.value ""
      ]
      [] ]
    , Html.div [] [ Html.input
      [ Html.Attributes.type' "submit"
      , Html.Attributes.value "Log in"
      ]
      [] ]
    ]
