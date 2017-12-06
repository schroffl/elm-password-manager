module Main exposing (main)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onInput, onClick)
import Html.Styled.Keyed as Keyed
import Html as StandardHtml
import Navigation
import UrlParser
import Styles


type Msg
    = LocationChange Navigation.Location
    | Goto Route
    | PasswordInput String


type Route
    = LoginRoute
    | VaultRoute
    | NotFoundRoute


type alias Password =
    String


type alias Model =
    { route : Route
    , password : Password
    }


meta : String -> String -> Html Msg
meta name_ content_ =
    node "meta" [ name name_, content content_ ] []


matchers : UrlParser.Parser (Route -> a) a
matchers =
    UrlParser.oneOf
        [ UrlParser.map LoginRoute <| UrlParser.s "login"
        , UrlParser.map VaultRoute <| UrlParser.top
        ]


parseLocation : Navigation.Location -> Route
parseLocation location =
    let
        result =
            UrlParser.parsePath matchers location
    in
        case result of
            Just route ->
                route

            Nothing ->
                NotFoundRoute


goto : Route -> Cmd Msg
goto route =
    Navigation.newUrl <|
        case route of
            LoginRoute ->
                "/login"

            VaultRoute ->
                "/"

            NotFoundRoute ->
                "/"


main : Program Never Model Msg
main =
    Navigation.program LocationChange
        { init = init
        , subscriptions = always Sub.none
        , update = update
        , view = view
        }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( { route = parseLocation location
      , password = ""
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LocationChange location ->
            ( { model | route = parseLocation location }
            , Cmd.none
            )

        Goto route ->
            ( model, goto route )

        PasswordInput newPassword ->
            ( { model | password = newPassword }, Cmd.none )


view : Model -> StandardHtml.Html Msg
view model =
    let
        containerDiv =
            toUnstyled
                << Keyed.node "div" [ css Styles.container ]
                << (::) ( "viewport-meta", meta "viewport" "width=device-width, initial-scale=1, user-scalable=no" )
    in
        containerDiv <|
            case model.route of
                LoginRoute ->
                    [ ( "lock", lockView model.password False ) ]

                VaultRoute ->
                    [ ( "lock", lockView model.password True )
                    , ( "vault", vaultView )
                    ]

                NotFoundRoute ->
                    [ ( "not-found", text "404 Not Found" ) ]


lockView : Password -> Bool -> Html Msg
lockView password unlocked =
    let
        additionalStyles =
            if unlocked then
                Styles.lockUnlocked
            else
                []
    in
        div
            [ css <| Styles.lock ++ additionalStyles ]
            [ div [ css Styles.lockInputContainer ]
                [ input
                    [ type_ "password"
                    , placeholder "Password"
                    , onInput PasswordInput
                    , value password
                    , css Styles.lockInput
                    ]
                    []
                , button [ onClick <| Goto VaultRoute ] [ text "login" ]
                ]
            ]


vaultView : Html Msg
vaultView =
    div
        [ onClick <| Goto LoginRoute
        ]
        [ text "Vault Route" ]


vaultHeader : Html Msg
vaultHeader =
    div [] []
