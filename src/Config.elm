module Config exposing (..)

import Dict
import Resources exposing (..)


cfg =
    { lumberCoef = 0.01
    , ironCoef = 0.02
    , waterCoef = 0.03
    , manaRegenRate = 0.01
    , summonSkelCost =
        [ ( Mana, 20 ) ]
    , altarCosts =
        Dict.fromList
            [ ( 2
              , [ ( Iron, 20 )
                , ( Lumber, 20 )
                , ( Water, 20 )
                ]
              )
            , ( 3
              , [ ( Iron, 100 )
                , ( Lumber, 100 )
                , ( Water, 100 )
                ]
              )
            , ( 4
              , [ ( Iron, 200 )
                , ( Lumber, 200 )
                , ( Water, 200 )
                ]
              )
            ]
    }
