#!/usr/bin/env stack
-- stack --resolver lts-17.9 --install-ghc script --package filepath --package directory --package containers
{-# LANGUAGE ViewPatterns #-}


import System.FilePath
import System.Directory
import Control.Monad
import Control.Applicative
import qualified Data.Set as Set

-- TODO take after this style to this nicer to deal with
-- https://web.engr.oregonstate.edu/~erwig/papers/DeclScripting_SLE09.pdf

filterQCDirs :: [FilePath] -> [FilePath]
filterQCDirs = filter (\p -> ((== "qc") $ take 2 p))

--TODO use new serial newtype
neededFileSet :: String -> Set.Set FilePath
neededFileSet serial = Set.fromList serialedFiles
    where serialedFiles = liftA2 (++) [serial] [".fbd", ".stl", "fit.stl", ".3dm", "_report.txt", ".ginspect"]

--TODO change string type to serial
containsNeededFiles :: String -> [FilePath] -> Bool
containsNeededFiles serial entries = let entrySet = Set.fromList entries in
                                Set.isSubsetOf (neededFileSet serial) entrySet

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


type FileSet = Set.Set FilePath
newtype Serial = MkSerial String -- we could newtype smart constructor this

mkSerial :: String -> Maybe Serial
mkSerial s@(splitAt 3 -> ("20A", xs)) = Just $ MkSerial s
mkSerial _ = Nothing
