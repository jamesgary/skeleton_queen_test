module Main exposing (main)

import Browser
import Browser.Events
import Config exposing (..)
import Resources exposing (..)
import Time exposing (Posix)
import Types exposing (..)
import View exposing (view)


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { inv =
            { mana = 100
            , iron = 0
            , lumber = 0
            , water = 0
            }
      , visibleInv =
            Resources.init False
                |> (\inv -> { inv | mana = True })
      , graveyardSkelAmt = 1
      , forestSkelAmt = 2
      , mineSkelAmt = 3
      , riverSkelAmt = 4
      , altarLvl = 2
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( case msg of
        SummonSkel ->
            { model
                | graveyardSkelAmt = model.graveyardSkelAmt + 1
                , inv = deduct model.inv cfg.summonSkelCost
            }

        SendSkelFromTo fromLoc toLoc ->
            let
                deductedModel =
                    case fromLoc of
                        Graveyard ->
                            { model | graveyardSkelAmt = model.graveyardSkelAmt - 1 }

                        Forest ->
                            { model | forestSkelAmt = model.forestSkelAmt - 1 }

                        Mine ->
                            { model | mineSkelAmt = model.mineSkelAmt - 1 }

                        River ->
                            { model | riverSkelAmt = model.riverSkelAmt - 1 }

                wholeModel =
                    case toLoc of
                        Graveyard ->
                            { deductedModel | graveyardSkelAmt = deductedModel.graveyardSkelAmt + 1 }

                        Forest ->
                            { deductedModel | forestSkelAmt = deductedModel.forestSkelAmt + 1 }

                        Mine ->
                            { deductedModel | mineSkelAmt = deductedModel.mineSkelAmt + 1 }

                        River ->
                            { deductedModel | riverSkelAmt = deductedModel.riverSkelAmt + 1 }
            in
            wholeModel

        RecallFromForest ->
            { model
                | forestSkelAmt = model.forestSkelAmt - 1
                , graveyardSkelAmt = model.graveyardSkelAmt + 1
            }

        RecallFromMine ->
            { model
                | mineSkelAmt = model.mineSkelAmt - 1
                , graveyardSkelAmt = model.graveyardSkelAmt + 1
            }

        RecallFromRiver ->
            { model
                | riverSkelAmt = model.riverSkelAmt - 1
                , graveyardSkelAmt = model.graveyardSkelAmt + 1
            }

        UpgradeAltar ->
            { model | altarLvl = model.altarLvl + 1 }

        Tick delta ->
            { model
                | inv =
                    add model.inv
                        [ ( Mana, delta * cfg.manaRegenRate )
                        , ( Lumber, delta * cfg.lumberCoef * toFloat model.forestSkelAmt )
                        , ( Iron, delta * cfg.ironCoef * toFloat model.mineSkelAmt )
                        , ( Water, delta * cfg.waterCoef * toFloat model.riverSkelAmt )
                        ]
                , visibleInv =
                    Resources.map2
                        (\res amt isVisible ->
                            if amt > 0 then
                                True
                            else
                                isVisible
                        )
                        model.inv
                        model.visibleInv
            }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Browser.Events.onAnimationFrameDelta Tick
