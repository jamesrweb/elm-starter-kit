module Route exposing (Route(..), fromAppUrl, toHref)

import AppUrl exposing (AppUrl)


type Route
    = Counter
    | About
    | Home
    | Todos
    | Todo Int
    | NotFound


fromAppUrl : AppUrl -> Route
fromAppUrl appUrl =
    case appUrl.path of
        [] ->
            Home

        [ "about" ] ->
            About

        [ "counter" ] ->
            Counter

        [ "todo", id ] ->
            Maybe.map Todo (String.toInt id)
                |> Maybe.withDefault NotFound

        [ "todos" ] ->
            Todos

        _ ->
            NotFound


toHref : Route -> String
toHref =
    toAppUrl >> AppUrl.toString


toAppUrl : Route -> AppUrl
toAppUrl route =
    case route of
        Counter ->
            AppUrl.fromPath [ "counter" ]

        About ->
            AppUrl.fromPath [ "about" ]

        Home ->
            AppUrl.fromPath []

        Todos ->
            AppUrl.fromPath [ "todos" ]

        Todo id ->
            AppUrl.fromPath [ "todo", String.fromInt id ]

        NotFound ->
            AppUrl.fromPath [ "not-found" ]
