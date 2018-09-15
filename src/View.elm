module View exposing (view)

import Html exposing (Html, button, div, text)
import Html.Attributes exposing (disabled, style)
import Html.Events exposing (onClick)
import Types exposing (..)


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
