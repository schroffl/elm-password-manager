module Styles exposing (..)

import Css exposing (..)
import Css.Media as Media exposing (withMedia)


type alias Theme =
    { primary : Color
    , secondary : Color
    , highlightColor : Color
    }


defaultTheme : Theme
defaultTheme =
    { primary = hsl 0 0 0.95
    , secondary = hex "ccc"
    , highlightColor = hex "80bdff"
    }


smallWidth : Media.MediaQuery
smallWidth =
    Media.all [ Media.maxWidth (px 800) ]


smallHeight : Media.MediaQuery
smallHeight =
    Media.all [ Media.maxHeight (px 500) ]


container : List Style
container =
    [ position absolute
    , overflowX hidden
    , width (pct 40)
    , marginLeft (pct 30)
    , marginRight (pct 30)
    , border3 (px 1) solid defaultTheme.secondary
    , borderRadius (px 3)
    , top (px 20)
    , bottom (px 20)
    , withMedia [ smallWidth ]
        [ width (pct 100)
        , margin (px 0)
        , top (px 0)
        , bottom (px 0)
        ]
    ]


navbar : List Style
navbar =
    let
        h =
            (px 50)
    in
        [ displayFlex
        , listStyle none
        , width (pct 100)
        , height h
        , lineHeight h
        , backgroundColor defaultTheme.primary
        , borderBottom3 (px 1) solid defaultTheme.secondary
        , Css.boxShadow5 (px 0) (px 0) (px 5) (px 1) defaultTheme.secondary
        ]


navbarItem : List Style
navbarItem =
    [ flexGrow (num 1)
    , textAlign center
    , cursor pointer
    , hover
        [ color defaultTheme.highlightColor
        ]
    ]


lock : List Style
lock =
    [ position absolute
    , backgroundColor defaultTheme.primary
    , width (pct 100)
    , height (pct 100)
    , backgroundImage (url "/img/gear.svg")
    , backgroundRepeat noRepeat
    , backgroundSize contain
    , backgroundPosition center
    , displayFlex
    , alignItems center
    , justifyContent center
    , property "transition" "margin-left ease-out 300ms"
    ]


lockUnlocked : List Style
lockUnlocked =
    [ marginLeft (pct -100)
    ]


lockInputContainer : List Style
lockInputContainer =
    [ position relative
    , width (pct 50)
    , margin (px 0)
    , padding (px 0)
    , displayFlex
    , flexWrap wrap
    , justifyContent center
    , withMedia [ smallWidth ]
        [ width (pct 60) ]
    ]


lockInput : List Style
lockInput =
    [ width (pct 100)
    , height (px 35)
    , fontSize (px 18)
    , border3 (px 1) solid defaultTheme.secondary
    , borderRadius (px 3)
    , textAlign center
    , property "transition" "border-color 100ms linear"
    , focus
        [ outline none
        , borderColor defaultTheme.highlightColor
        ]
    , withMedia [ smallHeight ]
        [ height (px 20)
        , fontSize (px 15)
        ]
    ]
