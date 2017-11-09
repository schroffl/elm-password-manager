module Setup exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type Msg
    = ServerChange String
    | UsernameChange String
    | PasswordChange String


type alias Model =
    { server : String
    , username : String
    , password : String
    }


init : Model
init =
    { server = ""
    , username = ""
    , password = ""
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ServerChange newServer ->
            ( { model | server = newServer }, Cmd.none )

        UsernameChange newUsername ->
            ( { model | username = newUsername }, Cmd.none )

        PasswordChange newPassword ->
            ( { model | password = newPassword }, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "setup" ]
        [ input
            [ type_ "text"
            , onInput ServerChange
            , value model.server
            , placeholder "Server"
            ]
            []
        , input
            [ type_ "text"
            , onInput UsernameChange
            , value model.username
            , placeholder "Username"
            ]
            []
        , input
            [ type_ "password"
            , onInput PasswordChange
            , value model.password
            , placeholder "Password"
            ]
            []
        , button [ class "btn-unlock" ] [ text "Unlock" ]
        ]
