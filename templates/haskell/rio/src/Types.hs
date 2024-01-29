-- | Project-wide type definitions.
-- |
-- | Note that this is re-expored from `Import`, so these types should truly be
-- | considered project-wide.
module Types
  ( App (..),
    Options (..),
  )
where

import RIO
import RIO.Process

-- | App-wide context for this app.
-- | This is usually used as the `RIO` reader parameter for this app.
data App = App
  { appOptions :: !Options,
    appLogFunc :: !LogFunc,
    appProcessContext :: !ProcessContext
  }

instance HasLogFunc App where
  logFuncL = lens appLogFunc (\x y -> x {appLogFunc = y})

-- | Options for running this app via its main entrypoint.
data Options = Options
  { -- | If `True`, log messages will be more verbose.
    optionsVerbose :: !Bool,
    -- | Some integer option.
    optionsInt :: !Int,
    -- | Some float option, if specified.
    optionsFloat :: !(Maybe Float)
  }
