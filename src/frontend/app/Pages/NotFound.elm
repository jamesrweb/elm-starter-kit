module Pages.NotFound exposing (view)

import Html exposing (Html)


view : Html msg
view =
    Html.h1 [] [ Html.text "Not Found" ]
