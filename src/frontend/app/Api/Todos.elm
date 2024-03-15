module Api.Todos exposing (all, create)

import Json.Decode
import Models.Todo exposing (Todo)
import RemoteData exposing (WebData)
import RemoteData.Http


all : (WebData (List Todo) -> message) -> Cmd message
all handler =
    RemoteData.Http.get "https://jsonplaceholder.typicode.com/todos?limit=5" handler (Json.Decode.list Models.Todo.decode)


create : Int -> String -> (WebData Todo -> message) -> Cmd message
create id title handler =
    RemoteData.Http.post "https://jsonplaceholder.typicode.com/todos" handler Models.Todo.decode (Models.Todo.init { id = id, title = title } |> Models.Todo.encode)
