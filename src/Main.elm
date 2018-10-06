module Main exposing (main)

import Browser
import Browser.Events
import Config exposing (..)
import Locations exposing (..)
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
      , locSkels =
            Locations.init 0
      , altarLvl = 2
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ locSkels } as model) =
    ( case msg of
        SummonSkel ->
            { model
                | locSkels = { locSkels | graveyard = locSkels.graveyard + 1 }
                , inv = deduct model.inv cfg.summonSkelCost
            }

        SendSkelFromTo fromLoc toLoc ->
            { model
                | locSkels =
                    Locations.map
                        (\loc skelAmt ->
                            if loc == fromLoc then
                                skelAmt - 1
                            else if loc == toLoc then
                                skelAmt + 1
                            else
                                skelAmt
                        )
                        locSkels
            }

        UpgradeAltar ->
            { model | altarLvl = model.altarLvl + 1 }

        Tick delta ->
            { model
                | inv =
                    add model.inv
                        [ ( Mana, delta * cfg.manaRegenRate )
                        , ( Lumber, delta * cfg.lumberCoef * toFloat model.locSkels.forest )
                        , ( Iron, delta * cfg.ironCoef * toFloat model.locSkels.mine )
                        , ( Water, delta * cfg.waterCoef * toFloat model.locSkels.river )
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
