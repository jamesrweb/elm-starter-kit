module Pages.Todos exposing (Model, Msg, init, update, view)

import Api.Todos
import Cmd.Extra
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Models.Todo exposing (Todo)
import RemoteData exposing (WebData)
import Route
import Shared exposing (Shared)


type alias Model =
    { todos : WebData (List Todo)
    , next : String
    }


type Msg
    = ToggleTodo Todo
    | AddTodo
    | SetNextTodoName String
    | GotTodos (WebData (List Todo))
    | AddedTodo (WebData Todo)


init : Shared -> ( Model, Cmd Msg )
init _ =
    ( { todos = RemoteData.Loading, next = "" }, Api.Todos.all GotTodos )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        default : ( Model, Cmd Msg )
        default =
            Cmd.Extra.pure model
    in
    case msg of
        ToggleTodo todo ->
            let
                next : Todo
                next =
                    Models.Todo.toggle todo
            in
            RemoteData.map
                (\todos ->
                    Cmd.Extra.pure
                        { model
                            | todos =
                                RemoteData.succeed
                                    (List.map
                                        (\current ->
                                            if current == todo then
                                                next

                                            else
                                                current
                                        )
                                        todos
                                    )
                        }
                )
                model.todos
                |> RemoteData.withDefault default

        AddTodo ->
            if String.isEmpty model.next then
                default

            else
                model.todos
                    |> RemoteData.map (\todos -> ( { model | next = "" }, Api.Todos.create (List.length todos) model.next AddedTodo ))
                    |> RemoteData.withDefault default

        SetNextTodoName title ->
            Cmd.Extra.pure { model | next = title }

        GotTodos response ->
            Cmd.Extra.pure { model | todos = response }

        AddedTodo response ->
            model.todos
                |> RemoteData.map2 (\todo todos -> Cmd.Extra.pure { model | todos = (todos ++ [ todo ]) |> RemoteData.succeed }) response
                |> RemoteData.withDefault default


view : Shared -> Model -> Html Msg
view _ model =
    Html.main_ []
        [ viewTodoForm model.next
        , viewTodoItems model.todos
        ]


viewTodoForm : String -> Html Msg
viewTodoForm value =
    Html.form [ Html.Events.onSubmit AddTodo ]
        [ Html.input
            [ Html.Attributes.id "todo-form"
            , Html.Events.onInput SetNextTodoName
            , Html.Attributes.value value
            ]
            []
        , Html.button
            [ Html.Events.onClick AddTodo ]
            [ Html.text "Add todo" ]
        ]


viewTodoItem : Todo -> Html Msg
viewTodoItem todo =
    Html.li []
        [ Html.label []
            [ Html.input
                [ Html.Attributes.type_ "checkbox"
                , Html.Attributes.id (Models.Todo.id todo |> String.fromInt)
                , Html.Events.onClick (ToggleTodo todo)
                , Html.Attributes.checked (Models.Todo.completed todo)
                ]
                []
            , Html.text (Models.Todo.title todo ++ "\u{00A0}")
            , Html.a
                [ Models.Todo.id todo
                    |> Route.Todo
                    |> Route.toHref
                    |> Html.Attributes.href
                ]
                [ Html.text "view"
                ]
            ]
        ]


viewTodoItems : WebData (List Todo) -> Html Msg
viewTodoItems =
    RemoteData.mapBoth
        (List.map viewTodoItem >> Html.ul [])
        (Html.text "Something went wrong with loading the todos." |> always)
        >> RemoteData.withDefault (Html.text "Loading todos...")
