module Lib
  ( main2
  , fib
  , tablica
  , way
  ) where

import           System.Random

main2 :: StdGen -> IO ()
main2 gen = putStr $ show $ take 2 $ randomss gen

fib :: [Integer]
fib = fibSeq 0 1
  where
    fibSeq a b = a : fibSeq b (a + b)

randomss :: StdGen -> [Int]
randomss gen = num : randomss gen2
  where
    (num, gen2) = random gen
tablica :: [Int]
tablica = [50, 10, 30, 5, 90, 20, 40, 2, 25, 10, 8, 0]

group :: Int -> [a] -> [[a]]
group _ []  = []
group n tab = take n tab : group n (drop n tab)

way :: [Integer] -> [(Integer, [String])]
way tab = way2 (group 3 tab) 0 0 [] []
  where
    way2 [] wa wb patha pathb
      | wa == wb = [(wa, patha), (wb, pathb)]
      | min wa wb == wa = [(wa, patha)]
      | min wa wb == wb = [(wb, pathb)]
      | otherwise = [(0, [])]
    way2 ([a, b, c]:xs) wa wb patha pathb = way2 xs shortesta shortestb newa newb
      where
        shortesta = min (wa + a) (wb + b + c)
        shortestb = min (wb + b) (wa + a + c)
        newa
          | shortesta == (wa + a) = patha ++ ["A"]
          | shortesta == (wb + b + c) = pathb ++ ["B", "C"]
          | otherwise = []
        newb
          | shortestb == (wb + b) = pathb ++ ["B"]
          | shortestb == (wa + a + c) = patha ++ ["A", "C"]
          | otherwise = []
    way2 _ _ _ _ _ = [(0, ["zła droga"])]
