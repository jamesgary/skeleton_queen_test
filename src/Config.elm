module Config exposing (..)

import Resources exposing (..)


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


altarCost =
    [ ( Iron, 1000 )
    , ( Lumber, 1000 )
    , ( Water, 1000 )
    ]
