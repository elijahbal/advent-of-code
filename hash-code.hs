import qualified Data.HashMap.Strict as HashMap
import qualified Data.List as List


type FullName = String
type Name = String
type SectorId = Int
type HashCode = [Char]
computeHashCode :: FullName -> HashCode
computeHashCode name = undefined


freqTable :: Name -> [(Char, Int)]
freqTable name = computeFreqTable HashMap.empty name 
    where 
        computeFreqTable hashmap (x:xs) 
            | oldValue == Nothing = computeFreqTable (HashMap.insert x 1 hashmap) xs
            | otherwise = computeFreqTable (HashMap.adjust (+1) x hashmap) xs
            where oldValue = HashMap.lookup x hashmap;
        computeFreqTable hashmap [] = HashMap.toList hashmap
        

getSectorId :: Name -> SectorId
getSectorId name = read (getInteger name [])
    where { 
        getInteger (x:xs) store
            | x `elem` ['0'..'9'] = getInteger xs (x:store)
            | otherwise = getInteger xs store ;
        getInteger [] store = reverse store;
    }

getCode :: Name -> HashCode
getCode = take 5 . map fst . List.sortBy cmpFreq . freqTable . getEncryptedName

getHash :: FullName -> HashCode
getHash (x:xs)
    | x /= '[' = getHash xs
    | otherwise = take 5 xs

cmpFreq :: (Char, Int) -> (Char, Int) -> Ordering
cmpFreq (x,y) (x',y') = flip compare (y,x') (y',x)
getEncryptedName :: FullName -> Name
getEncryptedName fullName = getName fullName [] 
    where {
        getName (x:xs) store 
            | x `elem` ['a'..'z'] = getName xs (x:store)
            | x == '-' = getName xs store
            | otherwise = getName [] store;
        getName [] store = reverse store;
    }
isValidName :: FullName -> Bool
isValidName fullname = getHash fullname == getCode fullname

ex4' = [ "aaaaa-bbb-z-y-x-123[abxyz]"
        ,"a-b-c-d-e-f-g-h-987[abcde]"
        ,"not-a-real-room-404[oarel]"
        ,"totally-real-room-200[decoy]" ]
ex4 = lines <$> readFile "input_day_4.txt"



