{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE PartialTypeSignatures #-}
module MyLayout
  ( myLayout
  , myNav2DConfig
  , layoutKeys
  ) where

import           MyTheme
import           XMonad
import           XMonad.Actions.SinkAll              (sinkAll)
import           XMonad.Actions.Navigation2D         (Navigation2DConfig(..)
                                                     , centerNavigation
                                                     , lineNavigation
                                                     , singleWindowRect
                                                     , windowGo
                                                     , windowSwap
                                                     )
import           XMonad.Hooks.ManageDocks            (avoidStruts)
import           XMonad.Layout.Accordion
import           XMonad.Layout.Decoration
import           XMonad.Layout.Gaps
import           XMonad.Layout.MultiToggle
import           XMonad.Layout.MultiToggle.Instances
import           XMonad.Layout.NoFrillsDecoration
import           XMonad.Layout.Renamed
import           XMonad.Layout.ResizableTile
import           XMonad.Layout.SimpleDecoration
import           XMonad.Layout.Simplest
import           XMonad.Layout.Spacing (Border(..), spacingRaw)
import           XMonad.Layout.SubLayouts
import           XMonad.Layout.Tabbed
import           XMonad.Layout.WindowNavigation (windowNavigation)

type Keybinding = (KeyCombo, X ())
type KeyCombo = (KeyMask, KeySym)


myNav2DConfig :: Navigation2DConfig
myNav2DConfig = def
  { defaultTiledNavigation    = centerNavigation
  , floatNavigation           = centerNavigation
  , screenNavigation          = lineNavigation
  , layoutNavigation          = [("Full", centerNavigation)]
  , unmappedWindowRect        = [("Full", singleWindowRect)]
  }

addTopBar = noFrillsDeco shrinkText myTopBarTheme

gap = 5
-- mySpacing = spacing gap

myFlex = trimNamed 5 "Flex"
       $ windowNavigation
       $ addTopBar
       $ addTabs shrinkText myTabTheme
       $ subLayout [] Simplest
       $ tall
  where
    trimNamed w n = renamed [ (CutWordsLeft w), (PrependWords n) ]
    suffixed n = renamed [ (AppendWords n) ]
    tall = suffixed "Std 1/2" $ ResizableTall 1 (1/20) (1/2) []

myTabs = tabbed shrinkText myTabTheme

myLayout = avoidStruts
         $ toggleMirror
         $ toggleFull
         $ myFlex ||| myTabs
  where
    toggleFull = mkToggle (single FULL)
    toggleMirror = mkToggle (single MIRROR)

layoutKeys :: KeyMask -> [Keybinding]
layoutKeys super =
  [ -- Tile all floating windows
    ((super .|. shiftMask, xK_t), sinkAll)
  , -- Toggle full screen
    ((super, xK_Return), sendMessage $ Toggle FULL)
  , -- Toggle mirror
    ((super, xK_m), sendMessage $ Toggle MIRROR)
    -- Toggle between layouts
  , ((super, xK_grave), sendMessage NextLayout)

    -- Directional window navigation
  , ((super,                 xK_Right), windowGo R True)
  , ((super,                 xK_Left ), windowGo L True)
  , ((super,                 xK_Up   ), windowGo U True)
  , ((super,                 xK_Down ), windowGo D True)
  , ((super .|. shiftMask, xK_Right), windowSwap R True)
  , ((super .|. shiftMask, xK_Left ), windowSwap L True)
  , ((super .|. shiftMask, xK_Up   ), windowSwap U True)
  , ((super .|. shiftMask, xK_Down ), windowSwap D True)

  -- Sublayouts
  , ((super .|. controlMask, xK_h), sendMessage $ pullGroup L)
  , ((super .|. controlMask, xK_l), sendMessage $ pullGroup R)
  , ((super .|. controlMask, xK_k), sendMessage $ pullGroup U)
  , ((super .|. controlMask, xK_j), sendMessage $ pullGroup D)

    -- Merge all into sublayout
  , ((super, xK_m), withFocused (sendMessage . MergeAll))
    -- Un-merge from sublayout
  , ((super .|. shiftMask, xK_m), withFocused (sendMessage . UnMerge))
  ]
