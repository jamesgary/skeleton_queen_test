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
    { skelAmt : Int
    , manaAmt : Float
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { skelAmt = 0
      , manaAmt = 100
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = SummonSkel
    | Tick Float


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( case msg of
        SummonSkel ->
            { model
                | skelAmt = model.skelAmt + 1
                , manaAmt = model.manaAmt - 20
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
        , text ("Skeletons: " ++ String.fromInt model.skelAmt)
        , div [] []
        , button [ onClick SummonSkel, disabled (model.manaAmt < 20) ] [ text "Summon Skeleton (20 mana)" ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Browser.Events.onAnimationFrameDelta Tick
