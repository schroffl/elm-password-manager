module Main exposing (main)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onInput, onClick)
import Html.Styled.Keyed as Keyed
import Html as StandardHtml
import Navigation
import UrlParser
import Styles
import Icons


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


type alias Id =
    String


type alias Entry =
    { id : Id
    , name : String
    , iconUrl : String
    , username : String
    , password : String
    }


type alias Model =
    { route : Route
    , password : Password
    , entries : List Entry
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


{-| NOTE: Remove this function. It's currently only used for filling the entry-list of the model
-}
repeat : Int -> a -> List a
repeat n_ x_ =
    let
        repeat_ n x xs =
            if n <= 0 then
                xs
            else
                x :: repeat_ (n - 1) x xs
    in
        repeat_ n_ x_ []


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( { route = parseLocation location
      , password = ""
      , entries =
            repeat 100
                { id = "a8df777e"
                , name = "Test"
                , iconUrl = "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Elm_logo.svg/512px-Elm_logo.svg.png"
                , username = "test-user"
                , password = "123456"
                }
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
        shared =
            [ ( "viewport-meta", meta "viewport" "width=device-width, initial-scale=1, user-scalable=no" )
            , ( "lock", lockView model.password (model.route /= LoginRoute) )
            , ( "navbar", navbar model.route )
            ]

        containerDiv =
            toUnstyled
                << Keyed.node "div" [ css Styles.container ]
                << (++) shared
    in
        containerDiv <|
            case model.route of
                LoginRoute ->
                    []

                VaultRoute ->
                    [ ( "vault", vaultView model.entries ) ]

                NotFoundRoute ->
                    [ ( "not-found", text "404 Not Found" ) ]


navbar : Route -> Html Msg
navbar activeRoute =
    let
        navbutton btnroute content =
            if btnroute == activeRoute then
                li [ css Styles.navbarItem ] [ text content ]
            else
                li [ css Styles.navbarItem, onClick <| Goto btnroute ] [ text content ]
    in
        [ ( VaultRoute, "Vault" ), ( LoginRoute, "Logout" ) ]
            |> List.map (uncurry navbutton)
            |> nav [ css Styles.navbar ]


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


vaultView : List Entry -> Html Msg
vaultView entries =
    entries
        |> List.map (\entry -> ( entry.id, entryView entry ))
        |> Keyed.ul [ css Styles.vault ]


entryView : Entry -> Html Msg
entryView entry =
    li [ css Styles.entry ]
        [ div [ css Styles.iconContainer ]
            [ img [ src entry.iconUrl, css Styles.entryIcon ] []
            ]
        , text entry.name
        , button [ css Styles.flatButton, title "Copy to clipboard" ] [ Icons.clipboard ]
        , button [ css Styles.flatButton, title "Edit" ] [ Icons.edit2 ]
        ]
