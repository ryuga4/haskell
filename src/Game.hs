module Game where

import           Data.List

field :: Int -> [[Status]]
field n = reverse $ field2 n
  where
    field2 0  = []
    field2 n2 = replicate n2 Filled : field2 (n2 - 1)

data Jump = Jump
  { jumpTo   :: (Int, Int)
  , jumpOver :: (Int, Int)
  } deriving (Show)

data Status
  = Filled
  | Empty
  | Cursor
  deriving (Show)

basejumps :: [Jump]
basejumps =
  [ Jump {jumpTo = (-2, 0), jumpOver = (-1, 0)}
  , Jump {jumpTo = (2, 0), jumpOver = (1, 0)}
  , Jump {jumpTo = (0, 2), jumpOver = (0, 1)}
  , Jump {jumpTo = (0, -2), jumpOver = (0, -1)}
  , Jump {jumpTo = (-2, -2), jumpOver = (-1, -1)}
  , Jump {jumpTo = (2, 2), jumpOver = (1, 1)}
  ]

getCell :: Int -> Int -> [[Status]] -> Maybe Status
getCell x y triangle
  | y >= length triangle = Nothing
  | y < 0 = Nothing
  | x >= length (triangle !! y) = Nothing
  | x < 0 = Nothing
  | otherwise = Just (triangle !! y !! x)

changeCell :: Int -> Int -> Status -> [[Status]] -> [[Status]]
changeCell _ _ _ [] = []
changeCell x y status (hd:tl)
  | y > 0 = hd : changeCell x (y - 1) status tl
  | otherwise = (take (x-1) hd ++ Empty : drop x hd) : tl

getJump :: Int -> Int -> Jump -> [[Status]] -> Maybe Status
getJump x y jump = getCell (x + fst (jumpTo jump)) (y + snd (jumpTo jump))

getJumps :: Int -> Int -> [Jump] -> [[Status]] -> [(Int, Int, Maybe Status)]
getJumps x y jumps triangle = map (\i -> (x + fst (jumpTo i), y + snd (jumpTo i), getJump x y i triangle)) jumps

printTriangle :: [[Status]] -> IO ()
printTriangle triangle = printTriangle2 (length triangle) triangle
  where
    printTriangle2 _ [] = return ()
    printTriangle2 len (x:xs) = do
      let len2 = length x
      putStr (intercalate "" $ replicate (len - len2) " ")
      putStrLn
        (intercalate "" $
         map
           (\i ->
              case i of
                Empty  -> "_ "
                Filled -> "¤ "
                Cursor -> "O ")
           x)
      printTriangle2 len xs

game :: [[Status]] -> IO ()
game triangle = do
  printTriangle triangle
  _ <- getLine
  game triangle
