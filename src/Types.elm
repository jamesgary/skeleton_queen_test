module Types exposing (..)

import Resources exposing (..)


type alias Model =
    { inv : Inventory
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
    | SendSkelToForest
    | SendSkelToMine
    | SendSkelToRiver
    | Tick Float


totalSkels : Model -> Int
totalSkels model =
    model.graveyardSkelAmt + model.forestSkelAmt + model.mineSkelAmt + model.riverSkelAmt