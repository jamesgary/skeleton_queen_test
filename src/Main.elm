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
      , graveyardSkelAmt = 0
      , forestSkelAmt = 0
      , mineSkelAmt = 0
      , riverSkelAmt = 0
      , altarLvl = 1
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

        SendSkelToForest ->
            { model
                | graveyardSkelAmt = model.graveyardSkelAmt - 1
                , forestSkelAmt = model.forestSkelAmt + 1
            }

        SendSkelToMine ->
            { model
                | graveyardSkelAmt = model.graveyardSkelAmt - 1
                , mineSkelAmt = model.mineSkelAmt + 1
            }

        SendSkelToRiver ->
            { model
                | graveyardSkelAmt = model.graveyardSkelAmt - 1
                , riverSkelAmt = model.riverSkelAmt + 1
            }

        Tick delta ->
            { model
                | inv =
                    add model.inv
                        [ ( Mana, delta * cfg.manaRegenRate )
                        , ( Lumber, delta * cfg.lumberCoef * toFloat model.forestSkelAmt )
                        , ( Iron, delta * cfg.ironCoef * toFloat model.mineSkelAmt )
                        , ( Water, delta * cfg.waterCoef * toFloat model.riverSkelAmt )
                        ]
            }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Browser.Events.onAnimationFrameDelta Tick
