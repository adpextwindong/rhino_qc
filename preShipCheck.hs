#!/usr/bin/env stack
-- stack --resolver lts-17.9 --install-ghc script --package filepath --package directory --package containers

import System.FilePath
import System.Directory
import Control.Monad
import Control.Applicative
import qualified Data.Set as Set

filterQCDirs :: [FilePath] -> [FilePath]
filterQCDirs = filter (\p -> ((== "qc") $ take 2 p))

neededFileSet :: String -> Set.Set FilePath
neededFileSet serial = Set.fromList serialedFiles
    where serialedFiles = liftA2 (++) [serial] [".fbd", ".stl", "fit.stl", ".3dm", "_report.txt"]

type Serial = String -- we could newtype smart constructor this
containsNeededFiles :: Serial -> [FilePath] -> Bool
containsNeededFiles s entries = let entrySet = Set.fromList entries in
                                Set.isSubsetOf (neededFileSet s) entrySet

--TODO TUI wrangling strategies of misnamed files

main = do
    qcDirs <- (liftM filterQCDirs) $ filterM doesDirectoryExist =<< listDirectory =<< getCurrentDirectory
    results <- forM qcDirs $ \dir -> do
        -- putStrLn $ "Checking " ++ dir
        let serial = drop 2 dir
        -- putStrLn $ "Serial: " ++ serial
        entries <- listDirectory dir
        if not $ containsNeededFiles serial entries
        then putStrLn $ serial ++ " missing files?" --TODO print missing files
        else return ()
        putStrLn ""
        return $ containsNeededFiles serial entries

    print $ filter (not . fst) $ zip results qcDirs
    return()
