module Main exposing (main)

import Html exposing (..)
import Crypto exposing (CryptoKey, CryptoError)


type Msg
    = GotKey (Result CryptoError CryptoKey)


type alias Model =
    {}


main =
    program
        { init = init
        , update = update
        , subscriptions = always Sub.none
        , view = view
        }


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    text "test"
