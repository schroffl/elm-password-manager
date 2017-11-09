module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (style)
import Crypto exposing (CryptoKey, CryptoError)
import Setup


type Msg
    = SetupMessage Setup.Msg


type alias Model =
    { setupModel : Setup.Model }


main =
    program
        { init = init
        , update = update
        , subscriptions = always Sub.none
        , view = view
        }


init : ( Model, Cmd Msg )
init =
    ( { setupModel = Setup.init }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetupMessage setupMsg ->
            let
                ( newModel, command ) =
                    Setup.update setupMsg model.setupModel
            in
                ( { model | setupModel = newModel }
                , Cmd.map SetupMessage command
                )


view : Model -> Html Msg
view model =
    div [ style [ ( "height", "100%" ) ] ]
        [ Html.map SetupMessage <| Setup.view model.setupModel
        ]
