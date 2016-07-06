{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Exception (catch, SomeException)
import Control.Monad (when)
import System.Environment (getArgs, getProgName)
import System.Exit (exitSuccess, exitFailure)

import Network.HaskellNet.IMAP
import Network.HaskellNet.IMAP.SSL

main :: IO ()
main = do
  args <- getArgs
  let argc = length args
  when (argc /= 2 && argc /= 3) $ do
    prog <- getProgName
    putStrLn $ prog ++ " <host> <port> [ca-bundle]"
    exitFailure

  when (argc == 3) $ do
    putStrLn "UNSUPPORTED"
    exitSuccess

  let host = args !! 0
      port = args !! 1
      settings = defaultSettingsIMAPSSL {
        sslPort = fromIntegral (read port :: Integer)
        }

  c <- catch (connectIMAPSSLWithSettings host settings)
             (\exception -> do
                 let _ = exception :: SomeException
                 putStrLn "VERIFY FAILURE"
                 exitSuccess
             )

  putStrLn "VERIFY SUCCESS"
  exitSuccess