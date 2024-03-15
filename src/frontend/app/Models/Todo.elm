module Models.Todo exposing (Todo, completed, decode, encode, id, init, title, toggle)

import Json.Decode
import Json.Encode


type Todo
    = Todo TodoConfig


completed : Todo -> Bool
completed (Todo config) =
    config.completed


decode : Json.Decode.Decoder Todo
decode =
    Json.Decode.map3 TodoConfig
        (Json.Decode.field "id" Json.Decode.int)
        (Json.Decode.field "title" Json.Decode.string)
        (Json.Decode.field "completed" Json.Decode.bool)
        |> Json.Decode.map Todo


encode : Todo -> Json.Encode.Value
encode (Todo todo) =
    Json.Encode.object
        [ ( "id", Json.Encode.int todo.id )
        , ( "title", Json.Encode.string todo.title )
        , ( "completed", Json.Encode.bool todo.completed )
        ]


id : Todo -> Int
id (Todo config) =
    config.id


init : { id : Int, title : String } -> Todo
init config =
    Todo
        { id = config.id
        , title = config.title
        , completed = False
        }


title : Todo -> String
title (Todo config) =
    config.title


toggle : Todo -> Todo
toggle (Todo config) =
    Todo { config | completed = not config.completed }


type alias TodoConfig =
    { id : Int
    , title : String
    , completed : Bool
    }
