module Components.Navigation exposing (Config, view)

import Html exposing (Html)
import Html.Attributes
import Html.Attributes.Extra
import Route exposing (Route)
import VitePluginHelper


type alias Config =
    { currentRoute : Route
    , routes : List { route : Route, label : String }
    }


view : Config -> Html msg
view config =
    List.map (toNavigationLinkItem config.currentRoute) config.routes
        |> List.append [ elmLogoItem ]
        |> Html.ul []


elmLogoItem : Html msg
elmLogoItem =
    Html.li []
        [ Html.img [ VitePluginHelper.asset "/images/elm-logo.png" |> Html.Attributes.src ] []
        ]


toNavigationLinkItem : Route -> { label : String, route : Route } -> Html msg
toNavigationLinkItem currentRoute { label, route } =
    Html.li []
        [ Html.a
            [ Route.toHref route |> Html.Attributes.href
            , Html.Attributes.Extra.attributeIf
                (currentRoute == route)
                (Html.Attributes.attribute "aria-current" "page")
            ]
            [ Html.text label ]
        ]
