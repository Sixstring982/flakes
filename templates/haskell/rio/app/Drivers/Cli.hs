{-# LANGUAGE TemplateHaskell #-}

-- | Command-line entrypoint.
module Drivers.Cli (main) where

import Import
import MyProject (run)
import Options.Applicative.Simple
import qualified Paths_my_project
import RIO.Process

-- | Runs a command-line interface to the program, parsing all relevant command-line arguments.
main :: IO ()
main = do
  (options, ()) <-
    simpleOptions
      $(simpleVersion Paths_my_project.version)
      "Header for command line arguments"
      "Program description, also for command line arguments"
      ( Options
          <$> switch
            ( long "verbose"
                <> help "Verbose logger output"
            )
          <*> option
            auto
            ( long "int"
                <> help "Int argument"
                <> metavar "INT"
            )
          <*> option
            auto
            ( long "float"
                <> help "Float argument"
                <> metavar "FLOAT"
                <> value Nothing
            )
      )
      empty
  logOptions <- logOptionsHandle stderr $ optionsVerbose options
  processContext <- mkDefaultProcessContext
  withLogFunc logOptions $ \logFunc ->
    let app =
          App
            { appOptions = options,
              appLogFunc = logFunc,
              appProcessContext = processContext
            }
     in runRIO app run
