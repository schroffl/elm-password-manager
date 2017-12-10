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
        [ width unset
        , margin zero
        , top zero
        , bottom zero
        , left zero
        , right zero
        , border unset
        , borderRadius zero
        ]
    , fontFamily sansSerif
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

        -- , Css.boxShadow5 zero zero (px 5) (px 1) defaultTheme.secondary
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


flatButton : List Style
flatButton =
    [ backgroundColor transparent
    , border zero
    , cursor pointer
    , hover
        [ backgroundColor defaultTheme.primary
        ]
    , focus
        [ outline none
        ]
    , margin zero
    , padding zero
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
    , margin zero
    , padding zero
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


vault : List Style
vault =
    [ listStyle none
    , margin zero
    , padding zero
    , overflowY auto
    , height <| calc (pct 100) minus (px 51)
    ]


entry : List Style
entry =
    [ property "display" "grid"
    , property "grid-template-columns" "60px auto 60px 60px"
    , property "grid-template-rows" "60px"
    , lineHeight (px 60)
    , margin zero
    , padding zero
    , borderBottom3 (px 1) solid defaultTheme.secondary
    , withMedia [ smallHeight ]
        [ property "grid-template-columns" "50px auto 50px 50px"
        , property "grid-template-rows" "50px"
        , lineHeight (px 50)
        ]
    ]


iconContainer : List Style
iconContainer =
    [ margin (px 2)
    , padding (px 1)
    , border3 (px 2) solid defaultTheme.secondary
    , borderRadius (pct 50)
    , overflow hidden
    ]


iconBorderConnector : List Style
iconBorderConnector =
    []


entryIcon : List Style
entryIcon =
    [ width (pct 100)
    , borderRadius inherit

    {- width (pct 90)
       , margin auto
       , border3 (px 1) solid defaultTheme.secondary
       , borderRadius (pct 50)
    -}
    ]
