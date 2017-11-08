module Crypto exposing (CryptoKey, CryptoError(..), IV, generateKey, generateIV)

import Task exposing (Task)
import Native.Crypto


type CryptoKey
    = CryptoKey Int


type CryptoError
    = UnknownError String


type alias IV =
    List Int


convertError : String -> CryptoError
convertError str =
    case str of
        _ ->
            UnknownError str


generateKey : String -> Task CryptoError CryptoKey
generateKey password =
    Native.Crypto.generateKey password
        |> Task.map CryptoKey
        |> Task.mapError convertError


generateIV : Result CryptoError (List Int)
generateIV =
    -- Somehow the function is only properly called if it's applied to an argument
    -- That's why the zero is where it is
    Native.Crypto.generateIV 0
        |> Result.mapError convertError
