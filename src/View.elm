module View exposing (view)

import Config exposing (..)
import Dict exposing (Dict)
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (disabled, style)
import Html.Events exposing (onClick)
import Resources exposing (..)
import Types exposing (..)


view : Model -> Html Msg
view model =
    div
        [ style "display" "flex"
        , style "width" "600px"
        ]
        [ div [ style "width" "200px" ]
            (Resources.map2 viewResource model.inv model.visibleInv
                |> Resources.values
            )
        , div [ style "background-color" "#ddd", style "padding" "10px" ]
            [ div
                [ style "font-size" "20px"
                , style "text-align" "center"
                ]
                [ text ("Altar (Lvl " ++ String.fromInt model.altarLvl ++ ")")
                , if model.inv.lumber > 0 && model.inv.iron > 0 && model.inv.water > 0 && model.altarLvl < 4 then
                    button
                        [ disabled
                            (not
                                (canAfford model.inv
                                    (nextAltarCost model.altarLvl cfg.altarCosts)
                                )
                            )
                        , onClick UpgradeAltar
                        ]
                        [ text "Upgrade" ]
                  else
                    text ""
                ]
            , text ("Skeletons (total): " ++ String.fromInt (totalSkels model))
            , div [] []
            , text ("- In Graveyard: " ++ String.fromInt model.graveyardSkelAmt ++ " ")
            , button [ onClick SummonSkel, disabled (model.inv.mana < 20) ] [ text "Summon Skeleton (20 mana)" ]
            , div [] []
            , if totalSkels model > 0 then
                div []
                    [ viewLocation "Forest" model.forestSkelAmt Forest model.graveyardSkelAmt model.altarLvl
                    , viewLocation "Mine" model.mineSkelAmt Mine model.graveyardSkelAmt model.altarLvl
                    , viewLocation "River" model.riverSkelAmt River model.graveyardSkelAmt model.altarLvl
                    ]
              else
                text ""
            ]
        ]


nextAltarCost : Int -> Dict Int Cost -> Cost
nextAltarCost currentLvl altarCosts =
    case Dict.get (currentLvl + 1) altarCosts of
        Just cost ->
            cost

        Nothing ->
            Debug.todo ("Couldn't find altar cost for lvl " ++ String.fromInt (currentLvl + 1))


viewResource : Resource -> Float -> Bool -> Html Msg
viewResource resource amt isVisible =
    if isVisible then
        div []
            [ text (Resources.toString resource ++ ": " ++ String.fromInt (round amt))
            ]
    else
        text ""


viewLocation : String -> Int -> Location -> Int -> Int -> Html Msg
viewLocation locationName locationSkelAmt loc graveyardSkelAmt altarLvl =
    div []
        [ text ("- In " ++ locationName ++ ": " ++ String.fromInt locationSkelAmt)
        , button
            [ onClick (SendSkelFromTo Graveyard loc)
            , disabled (graveyardSkelAmt < 1)
            ]
            [ text ("Send (1) Skeleton to " ++ locationName) ]
        , if altarLvl >= 2 then
            button
                [ onClick (SendSkelFromTo loc Graveyard)
                , disabled (locationSkelAmt <= 0)
                ]
                [ text "Recall (1)" ]
          else
            text ""
        ]
