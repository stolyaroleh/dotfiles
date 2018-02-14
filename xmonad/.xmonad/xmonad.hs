import qualified Data.Map                            as M
import           Graphics.X11.ExtraTypes.XF86
import           XMonad
import           XMonad.Actions.CycleRecentWS
import           XMonad.Actions.DynamicProjects
import qualified XMonad.Actions.Search               as S
import           XMonad.Actions.SinkAll              (sinkAll)
import qualified XMonad.Actions.Submap               as SM
import           XMonad.Actions.WorkspaceNames       (renameWorkspace)
import           XMonad.Config.Mate                  (mateConfig)
import           XMonad.Hooks.EwmhDesktops           (fullscreenEventHook)
import           XMonad.Hooks.ManageDocks            (avoidStruts, docks, manageDocks)
import           XMonad.Hooks.ManageHelpers          (doFullFloat, isFullscreen)
import           XMonad.Layout
import           XMonad.Layout.Grid
import           XMonad.Layout.MultiToggle           (Toggle (..), mkToggle, single)
import           XMonad.Layout.MultiToggle.Instances
import           XMonad.Layout.NoBorders             (smartBorders)
import           XMonad.Layout.Tabbed                (simpleTabbed)
import           XMonad.Operations                   (kill)
import           XMonad.Prompt
import           XMonad.Util.EZConfig                (additionalKeys, checkKeymap, removeKeys)
import           XMonad.Util.Paste                   (sendKey)
import           XMonad.Util.Run                     (safeSpawn, unsafeSpawn)

-- PROMPT
myPrompt :: XPConfig
myPrompt = def

-- TODO (altercation/dotfiles-tilingwm):
-- named keybindings? EZConfig?
-- screencast, screenshot
-- Window on all workspaces
-- Windows + up/down to toggle full screen layout?

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

layoutKeys :: [Keybinding]
layoutKeys =
  [ -- tile all floating windows
    ((super .|. shiftMask, xK_t), sinkAll)
  , -- toggle mirror
    ((super, xK_m), sendMessage $ Toggle MIRROR)
    -- toggle between layouts
  , ((super, xK_grave), sendMessage NextLayout)
  ]

appKeys :: [Keybinding]
appKeys = start <$>
 [ (xK_b, "google-chrome-stable")
 ]
 where
  start :: (KeySym, String) -> Keybinding
  start (key, app) = ((super .|. shiftMask, key), safeSpawn app [])

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
 , layoutKeys
 , promptKeys
 , volumeKeys
 , workspaceKeys
 ]

removedDefaults :: [KeyCombo]
removedDefaults =
  [ -- toggle between layouts
    (super, xK_space)
    -- set default layout
  , (super .|. shiftMask, xK_space)
    -- kill active window
  , (super .|. shiftMask, xK_c)
  ]

-- LAYOUTS
myLayout = smartBorders
         $ avoidStruts
         $ mirrorToggle
         $ tiled ||| Grid ||| Full
  where
    -- Default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio
    -- The default number of windows in the master pane
    nmaster = 1
    -- Default proportion of screen occupied by master pane
    ratio   = 1 / 2
    -- Percent of screen to increment by when resizing panes
    delta   = 3 / 100
    mirrorToggle = mkToggle (single MIRROR)

-- PROJECTS
myProjects :: [Project]
myProjects =
  [ Project { projectName = "email"
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
            , projectDirectory = "~/"
            , projectStartHook = Just $ do
                safeSpawn "code" ["-n"]
                safeSpawn "code" ["-add", ".xmonad", "src/xmonad", "src/xmonad-contrib", "/etc/nixos"]
                safeSpawn "termite" []
            }
  ]

myManageHook = composeAll
  [ manageHook mateConfig
  , manageDocks
  , isFullscreen --> doFullFloat
  ]

myConfig = docks $ mateConfig
  { modMask = super
  , borderWidth = 1
  , handleEventHook = fullscreenEventHook
  , layoutHook = myLayout
  , manageHook = myManageHook
  , terminal = "termite"
  }
  `additionalKeys` myKeys
  `removeKeys` removedDefaults

main :: IO ()
main = xmonad $ dynamicProjects myProjects myConfig
