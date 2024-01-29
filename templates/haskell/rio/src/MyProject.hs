module MyProject (run) where

import Import

-- | Main library entrypoint.
run :: RIO App ()
run = logInfo "hello, world"
