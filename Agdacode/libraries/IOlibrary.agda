open import constantparameters

module libraries.IOlibrary where

open import Data.Nat
open import Data.List hiding (_++_)
open import Agda.Builtin.Nat using (_-_; _*_)
open import Data.Unit
open import Data.Bool
open import Data.Bool.Base
open import Data.Nat.Base
open import Data.Maybe hiding (_>>=_)
open import Data.String hiding (length;show)
open import Data.Nat.Show
open import Data.Maybe.Base as Maybe using (Maybe; nothing; _<∣>_; when)
import Data.Maybe.Categorical as Maybe
open import Data.Product renaming (_,_ to _,,_ )
open import Agda.Builtin.String

--our work
open import libraries.natCompare
open import libraries.Mainlibrary
open import interface.ConsoleLib
open import Complex-Model.ccomand.ccommands-cresponse
open import basicDataStructure



string2FunctionName : String → Maybe FunctionName
string2FunctionName str = just str




funname2string : FunctionName → String
funname2string x = x



mutual
  msgList2String : List Msg → String
  msgList2String [] = ""
  msgList2String (msg ∷ []) = msg2string msg
  msgList2String (msg ∷ rest) = msg2string msg  ++ " , " ++ msgList2String rest


  msg2string : Msg → String
  msg2string (nat n)         = "(nat " ++ show n ++ ")"
  msg2string (msg +msg msg₁) =  "(" ++ msg2string msg ++ " , " ++ msg2string msg₁ ++ ")"
  msg2string (list l)        = "[" ++ msgList2String l ++ "]"


-- Test cases
-- msg2string (nat 5)
--    "(nat 5)""(nat 5)"
-- msg2string (list ((nat 3)  ∷ (nat 7) ∷ []))
--    "[(nat 3) , (nat 7) ]"
-- msg2string (list ((nat 3)  ∷ ((nat 7) +msg (nat 8) ) ∷ []))
--    "[(nat 3) , ((nat 7) , (nat 8))]"


errorMsg2Str : NatOrError → String
errorMsg2Str (nat n) = show n
errorMsg2Str (err (strErr s) ⟨ lastcalladdr >> curraddr ∙ lastfunname [ lastmsg ]⟩) = s
errorMsg2Str (err (numErr n) ⟨ lastcalladdr >> curraddr ∙ lastfunname [ lastmsg ]⟩) = show n
errorMsg2Str (err undefined ⟨ lastcalladdr >> curraddr ∙ lastfunname [ lastmsg ]⟩) = "Error undefined"
errorMsg2Str (err outOfGasError ⟨ lastcalladdr >> curraddr ∙ lastfunname [ lastmsg ]⟩) = "Out of gas error"
errorMsg2Str invalidtransaction = "invalidtransaction"


checkamount : Ledger → Address → ℕ
checkamount ledger addr = ledger addr .amount




-- define state for IO
record StateIO  : Set  where
       constructor ⟨_ledger,_initialAddr,_gas⟩
       field
        ledger       : Ledger
        initialAddr  : Address
        gas          : ℕ
open StateIO public




