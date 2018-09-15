module Main exposing (main)

import Browser
import Browser.Events
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



-- MODEL


init : () -> ( Model, Cmd Msg )
init _ =
    ( { manaAmt = 100
      , graveyardSkelAmt = 0
      , forestSkelAmt = 0
      , mineSkelAmt = 0
      , riverSkelAmt = 0
      , lumberAmt = 0
      , ironAmt = 0
      , waterAmt = 0
      , altarLvl = 1
      }
    , Cmd.none
    )



-- UPDATE


cfg =
    { lumberCoef = 0.01
    , ironCoef = 0.02
    , waterCoef = 0.03
    , manaRegenRate = 0.01
    , altarLvl2Price =
        { iron = 1000
        , lumber = 1000
        , water = 1000
        }
    }


summonSkelCost =
    [ ( Mana, 20 ) ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( case msg of
        SummonSkel ->
            { model
                | graveyardSkelAmt = model.graveyardSkelAmt + 1
                , manaAmt = model.manaAmt - 20
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
                | manaAmt = model.manaAmt + (delta * cfg.manaRegenRate)
                , lumberAmt = model.lumberAmt + (delta * cfg.lumberCoef * toFloat model.forestSkelAmt)
                , ironAmt = model.ironAmt + (delta * cfg.ironCoef * toFloat model.mineSkelAmt)
                , waterAmt = model.waterAmt + (delta * cfg.waterCoef * toFloat model.riverSkelAmt)
            }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Browser.Events.onAnimationFrameDelta Tick
