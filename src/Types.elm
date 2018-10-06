module Types exposing (..)

import Locations exposing (..)
import Resources exposing (..)


type alias Model =
    { inv : Inventory
    , visibleInv : ResourcesHandler Bool
    , locSkels : LocationsHandler Int
    , altarLvl : Int
    }


type Msg
    = SummonSkel
    | SendSkelFromTo Location Location
    | UpgradeAltar
    | Tick Float


totalSkels : Model -> Int
totalSkels model =
    Locations.sum model.locSkels
