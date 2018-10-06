module Types exposing (..)

import Resources exposing (..)


type alias Model =
    { inv : Inventory
    , visibleInv : ResourcesHandler Bool
    , graveyardSkelAmt : Int
    , forestSkelAmt : Int
    , mineSkelAmt : Int
    , riverSkelAmt : Int
    , altarLvl : Int
    }


type Location
    = Graveyard
    | Forest
    | Mine
    | River


type Msg
    = SummonSkel
    | SendSkelFromTo Location Location
    | RecallFromForest
    | RecallFromMine
    | RecallFromRiver
    | UpgradeAltar
    | Tick Float


totalSkels : Model -> Int
totalSkels model =
    model.graveyardSkelAmt + model.forestSkelAmt + model.mineSkelAmt + model.riverSkelAmt
