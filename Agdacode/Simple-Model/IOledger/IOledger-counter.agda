module Simple-Model.IOledger.IOledger-counter where

open import Data.Nat
open import Data.List hiding (_++_)
open import Data.Unit
open import Data.Bool
open import Data.Bool.Base
open import Data.Nat.Base
open import Data.Maybe hiding (_>>=_)
open import Data.String hiding (length;show)
open import Data.Nat.Show


open import Simple-Model.ledgerversion.Ledger-Simple-Model
open import Simple-Model.library-simple-model.basicDataStructureWithSimpleModel

open import Data.Nat.Show
open import interface.Console hiding (main)
open import interface.Unit
open import interface.NativeIO
open import interface.Base
open import Data.Maybe.Base as Maybe using (Maybe; nothing; _<∣>_; when)
import Data.Maybe.Categorical as Maybe
open import interface.ConsoleLib



-- string to function name
string2FunctionName : String → Maybe FunctionName
string2FunctionName str = if str  == "constnum"  then just "constnum"  else
                          (if str == "increment" then just "increment" else
                          (if str == "transfer"  then just "transfer"  else
                          nothing))
                          
-- define a function to convert error message to string
errorMsg2Str : ErrorMsg → String
errorMsg2Str (strErr s)  = s
errorMsg2Str (numErr n)  = show n
errorMsg2Str undefined   = "undefined"

mutual

-- first program to execute a function of a contract
  executeLedger      : ∀{i} → Ledger → (callAddr : Address) → IOConsole i Unit
  executeLedger ledger callAddr .force
      = exec' (putStrLn "Enter the Calling Address")
        λ _ → IOexec getLine 
        λ line → executeLedgerStep2 ledger callAddr (readMaybe 10 line)

  executeLedgerStep2 : ∀{i} → Ledger → (callAddr : Address) → Maybe ℕ → IOConsole i Unit
  executeLedgerStep2 ledger callAddr nothing .force
                   = exec' (putStrLn "Enter the Calling Address")
                     λ _ → IOexec getLine
                     λ _ →  executeLedger ledger callAddr
  executeLedgerStep2 ledger callAddr (just n) .force
   = exec' (putStrLn "Enter a function name as constnum, increment, or transfer")
     λ _ → IOexec getLine 
     λ line → executeLedgerStep3 ledger callAddr n (string2FunctionName line)

  
  executeLedgerStep3 : ∀{i} → Ledger → (callAddr : Address) → ℕ → Maybe FunctionName → IOConsole i Unit
  executeLedgerStep3 ledger callAddr n nothing .force
   = exec' (putStrLn "Enter a function name as constnum, increment, or transfer")
     λ _ → IOexec getLine
     λ _ → executeLedgerStep2 ledger callAddr (just n)
  
  executeLedgerStep3 ledger callAddr n (just f) .force
   = exec' (putStrLn "Enter the argument of the function name as a natural number")
     λ _ → IOexec getLine 
     λ line → executeLedgerStep4 ledger callAddr n f (readMaybe 10 line)
     
  
  executeLedgerStep4 : ∀{i} → Ledger → (callAddr : Address) → ℕ → FunctionName → Maybe ℕ → IOConsole i Unit
  executeLedgerStep4 ledger callAddr n f nothing .force
   = exec' (putStrLn "Enter the argument of the function name as a natural number")
     λ _ → IOexec getLine
     λ _ → executeLedgerStep3 ledger callAddr  n (just f)
  executeLedgerStep4 ledger callAddr n f (just m) .force 
   = executeLedgerStep5 (evaluateNonTerminatingWithLedger
     ledger callAddr n f (nat m)) callAddr 

  
  executeLedgerStep5 : ∀{i} → MsgAndLedger → (callAddr : Address) → IO' consoleI i Unit
  executeLedgerStep5 (msgAndLedger newLedger (theMsg (nat n))) callAddr 
    = exec' (putStrLn "The information you get is below: ")
      λ _ → IOexec (putStrLn ("The result is nat " ++ (show n)))
      λ _ → mainBody newLedger callAddr 
  executeLedgerStep5 (msgAndLedger newLedger (theMsg (list l))) callAddr 
    = exec' (putStrLn "Result is of form list l ")
      λ _ → mainBody newLedger callAddr                                
  executeLedgerStep5 (msgAndLedger newLedger (err e)) callAddr 
    = exec' (putStrLn "Error")
      λ _ → IOexec (putStrLn (errorMsg2Str e))
      λ _ → mainBody newLedger callAddr



-- Second program to look up the balance of one contract
  executeLedgercheckamount    : ∀{i} → Ledger → (callAddr : Address) → IOConsole i Unit                              
  executeLedgercheckamount ledger callAddr .force
   = exec' (putStrLn "Enter the Calling Address to look up the balance of the contract")
     λ _ → IOexec getLine 
     λ line → executeLedgercheckamountAux ledger callAddr (readMaybe 10 line)


  executeLedgercheckamountAux : ∀{i} → Ledger  → (callAddr : Address) → Maybe ℕ → IOConsole i Unit
  executeLedgercheckamountAux ledger callAddr nothing .force
   = exec' (putStrLn "Please enter an address as a number only")
     λ _ → executeLedgercheckamount ledger callAddr
  executeLedgercheckamountAux ledger callAddr (just calledAddr) .force
   = exec' (putStrLn "The information you get is below:  ")
     λ line → IOexec (putStrLn ("The available money is "
     ++ show (ledger calledAddr .amount)
     ++ " wei in address " ++ show calledAddr))
     (λ line → mainBody ledger callAddr)



--- third program to change the calling address
  executeLedgerChangeCallingAddress : ∀{i} → Ledger → (callAddr : Address) → IOConsole i Unit
  executeLedgerChangeCallingAddress ledger callAddr .force
   = exec' (putStrLn "Enter the new Calling Address")
     λ _ → IOexec getLine
     λ line → executeLedgerChangeCallingAddressAux ledger callAddr (readMaybe 10 line)


  executeLedgerChangeCallingAddressAux : ∀{i} → Ledger → (callAddr : Address) → Maybe Address → IOConsole i Unit
  executeLedgerChangeCallingAddressAux ledger callAddr (just callingAddr)
      = executeLedger ledger callAddr
  executeLedgerChangeCallingAddressAux ledger callAddr nothing .force
      = exec' (putStrLn "Please a number")
      λ _ → executeLedgerChangeCallingAddress ledger callAddr




-- define our interface  
  mainBody : ∀{i} → Ledger → (callAddr : Address) → IOConsole i  Unit
  mainBody ledger callAddr .force
    = WriteString' ("Please choose one of them:
                       1- Execute a function of a contract.
                       2- Look up the balance of one contract.
                       3- Change the calling address.
                       4- Terminate the program.")
   λ str → (GetLine >>= λ str →
   if str  == "1"
      then executeLedger ledger callAddr
   else (if str == "2"
      then executeLedgercheckamount ledger callAddr
   else (if str == "3"
      then executeLedgerChangeCallingAddress ledger callAddr
   else (if str == "4"
      then WriteString "The program is terminated"
   else mainBody ledger callAddr))))


