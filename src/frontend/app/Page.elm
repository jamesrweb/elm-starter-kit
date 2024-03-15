module Page exposing (Msg, Page(..), tick, update, view)

import Cmd.Extra
import Html exposing (Html)
import Pages.About
import Pages.Counter
import Pages.Home
import Pages.NotFound
import Pages.Todo
import Pages.Todos
import Route
import Shared exposing (Shared)


type Msg
    = CounterPageMessage Pages.Counter.Msg
    | TodosPageMessage Pages.Todos.Msg
    | TodoPageMessage Pages.Todo.Msg


type Page
    = Home
    | About
    | NotFound
    | Counter Pages.Counter.Model
    | Todos Pages.Todos.Model
    | Todo Pages.Todo.Model


tick : Shared -> ( Page, Cmd Msg )
tick shared =
    case Route.fromAppUrl (Shared.url shared) of
        Route.Counter ->
            Pages.Counter.init shared
                |> Tuple.mapBoth Counter (Cmd.map CounterPageMessage)

        Route.About ->
            Cmd.Extra.pure About

        Route.Home ->
            Cmd.Extra.pure Home

        Route.Todos ->
            Pages.Todos.init shared
                |> Tuple.mapBoth Todos (Cmd.map TodosPageMessage)

        Route.Todo id ->
            Pages.Todo.init shared id
                |> Tuple.mapBoth Todo (Cmd.map TodoPageMessage)

        Route.NotFound ->
            Cmd.Extra.pure NotFound


update : Msg -> Page -> ( Page, Cmd Msg )
update msg page =
    let
        default : ( Page, Cmd msg )
        default =
            Cmd.Extra.pure page
    in
    case page of
        Home ->
            default

        About ->
            default

        NotFound ->
            default

        Counter model ->
            case msg of
                CounterPageMessage message ->
                    updateCounterPage message model

                _ ->
                    default

        Todos model ->
            case msg of
                TodosPageMessage message ->
                    updateTodosPage message model

                _ ->
                    default

        Todo model ->
            case msg of
                TodoPageMessage message ->
                    updateTodoPage message model

                _ ->
                    default


view : Page -> Shared -> Html Msg
view page shared =
    case page of
        Home ->
            Pages.Home.view

        About ->
            Pages.About.view

        NotFound ->
            Pages.NotFound.view

        Counter counterModel ->
            Pages.Counter.view shared counterModel
                |> Html.map CounterPageMessage

        Todos todosModel ->
            Pages.Todos.view shared todosModel
                |> Html.map TodosPageMessage

        Todo todoModel ->
            Pages.Todo.view shared todoModel
                |> Html.map TodoPageMessage


updateCounterPage : Pages.Counter.Msg -> Pages.Counter.Model -> ( Page, Cmd Msg )
updateCounterPage message model =
    let
        ( nextModel, commands ) =
            Pages.Counter.update message model
    in
    ( Counter nextModel, Cmd.map CounterPageMessage commands )


updateTodoPage : Pages.Todo.Msg -> Pages.Todo.Model -> ( Page, Cmd Msg )
updateTodoPage message model =
    let
        ( nextModel, commands ) =
            Pages.Todo.update message model
    in
    ( Todo nextModel, Cmd.map TodoPageMessage commands )


updateTodosPage : Pages.Todos.Msg -> Pages.Todos.Model -> ( Page, Cmd Msg )
updateTodosPage message model =
    let
        ( nextModel, commands ) =
            Pages.Todos.update message model
    in
    ( Todos nextModel, Cmd.map TodosPageMessage commands )
