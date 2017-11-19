module Remote exposing (Token, login)

import Http
import Task exposing (Task)
import Json.Encode as Encode
import Json.Decode as Decode


type Token
    = Token String


login : String -> String -> String -> Http.Request Token
login server username password =
    let
        body =
            Encode.object
                [ ( "username", Encode.string username )
                , ( "password", Encode.string password )
                ]

        tokenDecoder =
            Decode.map Token
                (Decode.field "token" Decode.string)
    in
        Http.request
            { method = "POST"
            , headers = []
            , url = server
            , body = Http.jsonBody body
            , expect = Http.expectJson tokenDecoder
            , timeout = Nothing
            , withCredentials = False
            }
