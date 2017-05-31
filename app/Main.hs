module Main where

import Lib
import System.Random
import Game

main :: IO ()
main = do
  --gen <- getStdGen
  --main2 gen
  game (field 10)