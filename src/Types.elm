module Types exposing (..)


type alias Model =
    { manaAmt : Float
    , graveyardSkelAmt : Int
    , forestSkelAmt : Int
    , mineSkelAmt : Int
    , riverSkelAmt : Int
    , lumberAmt : Float
    , ironAmt : Float
    , waterAmt : Float
    , altarLvl : Int
    }


type Location
    = Graveyard
    | Forest



--| Mine
--| River


type alias Cost =
    List ( Resource, Float )


type Resource
    = Mana
    | Iron
    | Lumber
    | Water


canAfford : Model -> Cost -> Bool
canAfford model cost =
    let
        deductedModel =
            deduct model cost
    in
    (deductedModel.manaAmt >= 0)
        && (deductedModel.lumberAmt >= 0)
        && (deductedModel.ironAmt >= 0)
        && (deductedModel.waterAmt >= 0)


deduct : Model -> Cost -> Model
deduct model cost =
    List.foldl foldlDeductHelper model cost


foldlDeductHelper : ( Resource, Float ) -> Model -> Model
foldlDeductHelper ( resource, amt ) model =
    case resource of
        Mana ->
            { model | manaAmt = model.manaAmt - amt }

        Iron ->
            { model | ironAmt = model.ironAmt - amt }

        Lumber ->
            { model | lumberAmt = model.lumberAmt - amt }

        Water ->
            { model | waterAmt = model.waterAmt - amt }


type Msg
    = SummonSkel
    | SendSkelToForest
    | SendSkelToMine
    | SendSkelToRiver
    | Tick Float


totalSkels : Model -> Int
totalSkels model =
    model.graveyardSkelAmt + model.forestSkelAmt + model.mineSkelAmt + model.riverSkelAmt


altarCost =
    [ ( Iron, 1000 )
    , ( Lumber, 1000 )
    , ( Water, 1000 )
    ]
