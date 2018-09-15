module Main exposing (main)

import Browser
import Browser.Events
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (disabled, style)
import Html.Events exposing (onClick)
import Time exposing (Posix)


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


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


type alias Cost =
    List ( Resource, Float )


type Resource
    = Mana
    | Iron
    | Lumber
    | Water


summonSkelCost =
    [ ( Mana, 20 ) ]


altarCost =
    [ ( Iron, 1000 )
    , ( Lumber, 1000 )
    , ( Water, 1000 )
    ]


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



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ style "display" "flex"
        , style "width" "600px"
        ]
        [ div [ style "width" "200px" ]
            [ text ("Mana: " ++ String.fromInt (round model.manaAmt))
            , div [] []
            , text ("Lumber: " ++ String.fromInt (round model.lumberAmt))
            , div [] []
            , text ("Iron: " ++ String.fromInt (round model.ironAmt))
            , div [] []
            , text ("Water: " ++ String.fromInt (round model.waterAmt))
            ]
        , div [ style "background-color" "#ddd", style "padding" "10px" ]
            [ div
                [ style "font-size" "20px"
                , style "text-align" "center"
                ]
                [ text ("Altar (Lvl " ++ String.fromInt model.altarLvl ++ ")")
                , if model.lumberAmt > 0 && model.ironAmt > 0 && model.waterAmt > 0 then
                    button [ disabled (not (canAfford model altarCost)) ] [ text "Upgrade" ]
                  else
                    text ""
                ]
            , text ("Skeletons (total): " ++ String.fromInt (totalSkels model))
            , div [] []
            , text ("- In Graveyard: " ++ String.fromInt model.graveyardSkelAmt ++ " ")
            , button [ onClick SummonSkel, disabled (model.manaAmt < 20) ] [ text "Summon Skeleton (20 mana)" ]
            , div [] []
            , if totalSkels model > 0 then
                div []
                    [ viewLocation "Forest" model.forestSkelAmt SendSkelToForest model.graveyardSkelAmt
                    , viewLocation "Mine" model.mineSkelAmt SendSkelToMine model.graveyardSkelAmt
                    , viewLocation "River" model.riverSkelAmt SendSkelToRiver model.graveyardSkelAmt
                    ]
              else
                text ""
            ]
        ]


viewLocation : String -> Int -> Msg -> Int -> Html Msg
viewLocation locationName locationSkelAmt sendMsg graveyardSkelAmt =
    div []
        [ text ("- In " ++ locationName ++ ": " ++ String.fromInt locationSkelAmt)
        , button [ onClick sendMsg, disabled (graveyardSkelAmt < 1) ] [ text ("Send (1) Skeleton to " ++ locationName) ]
        ]


totalSkels : Model -> Int
totalSkels model =
    model.graveyardSkelAmt + model.forestSkelAmt + model.mineSkelAmt + model.riverSkelAmt


subscriptions : Model -> Sub Msg
subscriptions model =
    Browser.Events.onAnimationFrameDelta Tick
