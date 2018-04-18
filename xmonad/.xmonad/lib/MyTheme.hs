module MyTheme where

import           XMonad
import           XMonad.Layout.Decoration
import           XMonad.Prompt            (XPConfig)
import           XMonad.Util.Themes

-- COLORS
base00 = "#2d2d2d"
base01 = "#393939"
base02 = "#515151"
base03 = "#747369"
base04 = "#a09f93"
base05 = "#d3d0c8"
base06 = "#e8e6df"
base07 = "#f2f0ec"
base08 = "#f2777a"
base09 = "#f99157"
base0A = "#ffcc66"
base0B = "#99cc99"
base0C = "#66cccc"
base0D = "#6699cc"
base0E = "#cc99cc"
base0F = "#d27b53"

vscodeblue = "#006bb3"

myThemeInfo :: ThemeInfo
myThemeInfo = TI
  { themeName = "base16_eighties"
  , themeAuthor = "Oleh Stolyar"
  , themeDescription = "Based on colors from base16_eighties"
  , theme = def
    { activeColor = vscodeblue
    , inactiveColor = base00
    , urgentColor = base02
    , activeBorderColor = vscodeblue
    , inactiveBorderColor = base00
    , urgentBorderColor = base02
    , activeTextColor = base05
    , inactiveTextColor = base04
    , urgentTextColor = base08
    , fontName = "xft:Source Code Pro 6"
    }
  }

myTabTheme, myTopBarTheme :: Theme
myTabTheme = theme myThemeInfo
myTopBarTheme = theme myThemeInfo

myPrompt :: XPConfig
myPrompt = def
