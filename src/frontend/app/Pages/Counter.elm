module Pages.Counter exposing (Model, Msg, init, update, view)

import Html exposing (Html)
import Html.Events
import Shared exposing (Shared)


type alias Model =
    Int


type Msg
    = Increment
    | Decrement


init : Shared -> ( Model, Cmd Msg )
init _ =
    ( 0, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( model + 1, Cmd.none )

        Decrement ->
            ( model - 1, Cmd.none )


view : Shared -> Model -> Html Msg
view _ model =
    Html.div []
        [ Html.button [ Html.Events.onClick Decrement ] [ Html.text "-" ]
        , Html.div [] [ Html.text (String.fromInt model) ]
        , Html.button [ Html.Events.onClick Increment ] [ Html.text "+" ]
        ]
