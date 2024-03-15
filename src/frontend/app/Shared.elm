module Shared exposing (Shared, init, navigationKey, updateTimezone, updateUrl, url)

import AppUrl exposing (AppUrl)
import Browser.Navigation exposing (Key)
import Time


type Shared
    = Shared
        { navigationKey : Key
        , timezone : Time.Zone
        , url : AppUrl
        }


init : { navigationKey : Key, timezone : Time.Zone, url : AppUrl } -> Shared
init =
    Shared


navigationKey : Shared -> Key
navigationKey (Shared shared) =
    shared.navigationKey


updateTimezone : Time.Zone -> Shared -> Shared
updateTimezone updatedTimezone (Shared shared) =
    Shared { shared | timezone = updatedTimezone }


updateUrl : AppUrl -> Shared -> Shared
updateUrl updatedUrl (Shared shared) =
    Shared { shared | url = updatedUrl }


url : Shared -> AppUrl
url (Shared shared) =
    shared.url
