import qualified Data.Map                       as M
import           Graphics.X11.ExtraTypes.XF86
import           MyLayout
import           MyTheme
import           XMonad
import           XMonad.Actions.CycleRecentWS
import           XMonad.Actions.DynamicProjects
import           XMonad.Actions.Navigation2D    (withNavigation2DConfig)
import qualified XMonad.Actions.Search          as S
import           XMonad.Actions.SinkAll         (sinkAll)
import qualified XMonad.Actions.Submap          as SM
import           XMonad.Actions.WorkspaceNames  (renameWorkspace)
import           XMonad.Config.Mate             (mateConfig)
import           XMonad.Hooks.EwmhDesktops      (fullscreenEventHook)
import           XMonad.Hooks.ManageDocks       (docks, manageDocks)
import           XMonad.Hooks.ManageHelpers     (doFullFloat, isInProperty, isFullscreen)
import           XMonad.Layout
import           XMonad.Layout.Grid
import           XMonad.Layout.NoBorders        (smartBorders)
import           XMonad.Layout.Tabbed           (simpleTabbed)
import           XMonad.Operations              (kill, reveal)
import           XMonad.Prompt
import           XMonad.Util.EZConfig           (additionalKeys, checkKeymap,
                                                 removeKeys)
import           XMonad.Util.Paste              (sendKey)
import           XMonad.Util.Run                (safeSpawn, unsafeSpawn)

-- TODO (altercation/dotfiles-tilingwm):
-- named keybindings? EZConfig?
-- screencast, screenshot
-- Window on all workspaces
-- Workspace-based Chrome profiles
-- Named Scratchpads

-- KEYS
type KeyCombo = (KeyMask, KeySym)
type Keybinding = (KeyCombo, X ())

superKey = xK_Super_L :: KeySym
super = mod4Mask :: KeyMask
leftAlt = mod1Mask :: KeyMask

volumeKeys :: [Keybinding]
volumeKeys =
  [ ((super, xK_bracketleft), sendKey def xF86XK_AudioLowerVolume)
  , ((super, xK_bracketright), sendKey def xF86XK_AudioRaiseVolume)
  ]

appKeys :: [Keybinding]
appKeys = map start
 [ (xK_b, "google-chrome-stable")
 , (xK_p, launcher)
 ]
 where
  start :: (KeySym, String) -> Keybinding
  start (key, app) = ((super .|. shiftMask, key), safeSpawn app [])
  launcher :: String
  launcher = "synapse"

promptKeys :: [Keybinding]
promptKeys =
  [ ((super, xK_o), switchProjectPrompt myPrompt)
  , ((super .|. shiftMask, xK_o), shiftToProjectPrompt myPrompt)
  , ((super, xK_s), SM.submap $ searchEngineMap $ S.promptSearchBrowser myPrompt "google-chrome-stable")
  ]

searchEngineMap method = M.fromList $
  [ ((0, xK_g), method S.google)
  ]

workspaceKeys :: [Keybinding]
workspaceKeys =
  [ -- TODO rename workspace
    ((super, xK_F2), renameWorkspace myPrompt)
  , -- kill active window
    ((leftAlt, xK_F4), kill)
  , -- cycle recent workspaces
    ((super, xK_Tab), cycleRecentWS [superKey] xK_Left xK_Right)
  ]

myKeys :: [Keybinding]
myKeys = concat
 [ appKeys
 , layoutKeys super
 , promptKeys
 , volumeKeys
 , workspaceKeys
 ]

removedDefaults :: [KeyCombo]
removedDefaults =
  [ -- launcher
    (super, xK_p)
  , -- toggle between layouts
    (super, xK_space)
  , -- set default layout
    (super .|. shiftMask, xK_space)
  , -- kill active window
    (super .|. shiftMask, xK_c)
  ]

-- PROJECTS
myProjects :: [Project]
myProjects =
  [ Project { projectName = "gen"
            , projectDirectory = "~/"
            , projectStartHook = Nothing
            }
  , Project { projectName = "email"
            , projectDirectory = "~/Desktop"
            , projectStartHook = Just $ safeSpawn "google-chrome-stable" ["inbox.google.com", "--new-window"]
            }

  , Project { projectName = "web"
            , projectDirectory = "~/Downloads"
            , projectStartHook = Just $ safeSpawn "google-chrome-stable" []
            }

  , Project { projectName = "vlc"
            , projectDirectory = "~/"
            , projectStartHook = Just $ safeSpawn "vlc" []
            }

  , Project { projectName = "config"
            , projectDirectory = "~/dotfiles"
            , projectStartHook = Just $ do
                safeSpawn "code" ["-n", "."]
            }
  ]

myWorkspaces =
  [ "gen"
  , "web"
  , "email"
  , "vlc"
  , "config"
  ]
  ++ repeat 3 "code"
  where
    repeat n tag =
      [tag ++ "-" ++ show index | index <- [1..n]]

myManageHook = composeAll
  [ manageHook mateConfig
  , manageDocks
  , isFullscreen --> doFullFloat
  ]
  where
    isJetbrainsIDE :: Query Bool
    isJetbrainsIDE =
      className =? "jetbrains-pycharm-ce" <||>
      className =? "jetbrains-clion"

myConfig = docks $ mateConfig
  { modMask = super
  , borderWidth = 0
  , handleEventHook = fullscreenEventHook
  , layoutHook = myLayout
  , manageHook = myManageHook
  , terminal = "kitty"
  , workspaces = myWorkspaces
  }
  `additionalKeys` myKeys
  `removeKeys` removedDefaults

main :: IO ()
main = xmonad
  $ withNavigation2DConfig myNav2DConfig
  $ dynamicProjects myProjects myConfig
