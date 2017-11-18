module Crypto
    exposing
        ( CryptoKey
        , CryptoError(..)
        , IV
        , EncryptedData
        , generateKey
        , generateIV
        , encrypt
        , decrypt
        )

import Task exposing (Task)
import Native.Crypto


type CryptoKey
    = CryptoKey


type CryptoError
    = UnknownError String
    | BadKey


type alias IV =
    List Int


type alias EncryptedData =
    List Int


convertError : String -> CryptoError
convertError str =
    case str of
        "Bad Key" ->
            BadKey

        _ ->
            UnknownError str


generateKey : String -> Task CryptoError CryptoKey
generateKey password =
    -- TODO: Don't use a fixed salt
    Native.Crypto.generateKey password "salt" 19
        |> Task.mapError convertError


generateIV : Task CryptoError IV
generateIV =
    -- Somehow the function is only properly called if it's applied to an argument
    -- That's the only reason for the zero to be there
    Native.Crypto.generateIV 0
        |> Task.mapError convertError


encrypt : CryptoKey -> IV -> String -> Task CryptoError EncryptedData
encrypt key iv data =
    Native.Crypto.encrypt key iv data
        |> Task.mapError convertError


decrypt : CryptoKey -> IV -> EncryptedData -> Task CryptoError String
decrypt key iv data =
    Native.Crypto.decrypt key iv data
        |> Task.mapError convertError
