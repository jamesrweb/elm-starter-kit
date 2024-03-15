module Pages.Todo exposing (Model, Msg, init, update, view)

import Html exposing (Html)
import Shared exposing (Shared)


type alias Model =
    { id : Int
    }


type alias Msg =
    ()


init : Shared -> Int -> ( Model, Cmd Msg )
init _ id =
    ( { id = id }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )


view : Shared -> Model -> Html Msg
view _ model =
    Html.h1 [] [ Html.text ("Todo (id: " ++ String.fromInt model.id ++ ")") ]
