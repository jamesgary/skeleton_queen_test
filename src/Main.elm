module Main exposing (main)

import Browser
import Browser.Events
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (disabled)
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

    --, mineSkelAmt : Int
    --, riverSkelAmt : Int
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

      --, mineSkelAmt = 0
      --, riverSkelAmt = 0
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = SummonSkel
    | SendSkelToForest
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

        Tick delta ->
            { model
                | manaAmt = model.manaAmt + (delta * 0.01)
            }
    , Cmd.none
    )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ text ("Mana: " ++ String.fromInt (round model.manaAmt))
        , div [] []
        , text ("Skeletons (total): " ++ String.fromInt (totalSkels model))
        , div [] []
        , text ("- In Graveyard: " ++ String.fromInt model.graveyardSkelAmt ++ " ")
        , button [ onClick SummonSkel, disabled (model.manaAmt < 20) ] [ text "Summon Skeleton (20 mana)" ]
        , div [] []
        , text ("- In Forest: " ++ String.fromInt model.forestSkelAmt)
        , button [ onClick SendSkelToForest, disabled (model.graveyardSkelAmt < 1) ] [ text "Send (1) Skeleton to Forest" ]
        ]


totalSkels : Model -> Int
totalSkels model =
    model.graveyardSkelAmt + model.forestSkelAmt


subscriptions : Model -> Sub Msg
subscriptions model =
    Browser.Events.onAnimationFrameDelta Tick
