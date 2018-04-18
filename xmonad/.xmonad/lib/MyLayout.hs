{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE PartialTypeSignatures #-}
module MyLayout (
  myLayout,
  layoutKeys
) where

import           MyTheme
import           XMonad
import           XMonad.Actions.SinkAll              (sinkAll)
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
import           XMonad.Layout.Spacing
import           XMonad.Layout.SubLayouts
import           XMonad.Layout.Tabbed
import           XMonad.Layout.WindowNavigation

type Keybinding = (KeyCombo, X ())
type KeyCombo = (KeyMask, KeySym)

addTopBar = noFrillsDeco shrinkText myTopBarTheme

gap = 5
mySpacing = smartSpacingWithEdge gap

myFlex = trimNamed 5 "Flex"
       $ windowNavigation
       $ addTopBar
       $ addTabs shrinkText myTabTheme
       -- $ mySpacing
       $ subLayout [] (Simplest ||| Accordion)
       $ standardLayouts
  where
    trimNamed w n = renamed [ (CutWordsLeft w), (PrependWords n) ]
    suffixed n = renamed [ (AppendWords n) ]
    standardLayouts = (suffixed "Std 2/3" $ ResizableTall 1 (1/20) (2/3) [])
                  ||| (suffixed "Std 1/2" $ ResizableTall 1 (1/20) (1/2) [])

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
  [ -- tile all floating windows
    ((super .|. shiftMask, xK_t), sinkAll)
  , -- toggle full
    ((super, xK_Return), sendMessage $ Toggle FULL)
  , -- toggle mirror
    ((super, xK_m), sendMessage $ Toggle MIRROR)
    -- toggle between layouts
  , ((super, xK_grave), sendMessage NextLayout)
    -- window navigation
  , ((super,                 xK_Right), sendMessage $ Go R)
  , ((super,                 xK_Left ), sendMessage $ Go L)
  , ((super,                 xK_Up   ), sendMessage $ Go U)
  , ((super,                 xK_Down ), sendMessage $ Go D)
  , ((super .|. controlMask, xK_Right), sendMessage $ Swap R)
  , ((super .|. controlMask, xK_Left ), sendMessage $ Swap L)
  , ((super .|. controlMask, xK_Up   ), sendMessage $ Swap U)
  , ((super .|. controlMask, xK_Down ), sendMessage $ Swap D)
  ]
