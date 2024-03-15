module Main exposing (Flags, Model, Msg, main)

import AppUrl exposing (AppUrl)
import Browser exposing (Document, UrlRequest)
import Browser.Navigation exposing (Key)
import Cmd.Extra
import Components.Navigation
import Html
import Page exposing (Page)
import Route exposing (Route)
import Shared exposing (Shared)
import Task
import Time
import Url exposing (Url)


type alias Flags =
    ()


type alias Model =
    { shared : Shared
    , page : Page
    }


type Msg
    = OnUrlChange Url
    | OnUrlRequest UrlRequest
    | SetTimezone Time.Zone
    | PageMessage Page.Msg


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , onUrlChange = OnUrlChange
        , onUrlRequest = OnUrlRequest
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init _ url key =
    let
        appUrl : AppUrl
        appUrl =
            AppUrl.fromUrl url

        shared : Shared
        shared =
            Shared.init
                { navigationKey = key
                , timezone = Time.utc
                , url = appUrl
                }
    in
    Page.tick shared
        |> Tuple.mapFirst (Model shared)
        |> Tuple.mapSecond
            (\commands ->
                Cmd.batch
                    [ Cmd.map PageMessage commands
                    , Task.perform SetTimezone Time.here
                    ]
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnUrlChange url ->
            let
                appUrl : AppUrl
                appUrl =
                    AppUrl.fromUrl url

                nextModel : Page -> Model
                nextModel =
                    Model nextShared

                nextShared : Shared
                nextShared =
                    Shared.updateUrl appUrl model.shared
            in
            Page.tick nextShared
                |> Tuple.mapFirst nextModel
                |> Tuple.mapSecond (Cmd.map PageMessage)

        OnUrlRequest urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Browser.Navigation.pushUrl (Shared.navigationKey model.shared) (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , Browser.Navigation.load href
                    )

        SetTimezone timezone ->
            Cmd.Extra.pure { model | shared = Shared.updateTimezone timezone model.shared }

        PageMessage pageMsg ->
            let
                ( page, commands ) =
                    Page.update pageMsg model.page
            in
            ( { model | page = page }
            , Cmd.map PageMessage commands
            )


view : Model -> Document Msg
view model =
    let
        routes : List { label : String, route : Route }
        routes =
            [ { label = "Home"
              , route = Route.Home
              }
            , { label = "About"
              , route = Route.About
              }
            , { label = "Counter"
              , route = Route.Counter
              }
            , { label = "Todos"
              , route = Route.Todos
              }
            , { label = "Todo Example (id: 39)"
              , route = Route.Todo 39
              }
            ]
    in
    { title = "Elm Starter Kit"
    , body =
        [ Components.Navigation.view
            { currentRoute = Shared.url model.shared |> Route.fromAppUrl
            , routes = routes
            }
        , Page.view model.page model.shared
            |> Html.map PageMessage
        ]
    }
