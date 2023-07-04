module Simple-Model.example.examplecounter where

open import Data.Nat
open import Data.List
open import Data.Bool
open import Data.Bool.Base
open import Data.Nat.Base
open import Data.Maybe hiding (_>>=_)
open import Data.String hiding (length)


--simple model
open import Simple-Model.ledgerversion.Ledger-Simple-Model

--library
open import Simple-Model.library-simple-model.basicDataStructureWithSimpleModel
open import interface.ConsoleLib

--IOledger
open import Simple-Model.IOledger.IOledger-counter



--Example of a simple counter
const : ℕ → (Msg → SmartContract Msg)
const n msg = return (nat n)



mutual
  contract0 : FunctionName → (Msg → SmartContract Msg)
  contract0 "f1" = const 0
  contract0 "g1" = def-g1
  contract0 ow ow' = error (strErr " Error msg")

  def-g1 : Msg → SmartContract Msg
  def-g1 (nat x)  = exec currentAddrLookupc λ addr → call 0 "f1" (nat 0)
  def-g1 (list x) = exec currentAddrLookupc (λ n → exec (updatec "f1" (const (suc n))) λ _ → return (nat n))
    

-- test our ledger with our example
testLedger : Ledger

testLedger 0 .amount  = 20
testLedger 0 .fun "f1" m  = const 0 (nat 0)
testLedger 0 .fun "g1" m  = def-g1(nat 0)
testLedger 0 .fun "k1" m  = exec (getAmountc 0) (λ n → return (nat n))
testLedger 0 .fun  ow ow' = error (strErr "Undefined")

-- the example belw we used in our paper
testLedger 1 .amount             = 40
testLedger 1 .fun "constnum" m   = const 0 (nat 0)
testLedger 1 .fun "increment" m  = exec currentAddrLookupc  λ addr →
                                   exec (callc addr "constnum" (nat 0))
                                   λ{(nat n) → exec (updatec "constnum" (const (suc n)))
                                             λ _ → return (nat (suc n));
                                  _        → error (strErr "constnum returns not a number")}
testLedger 1 .fun "transfer" m  = exec (transferc 10  0) λ _ → return m

testLedger ow .amount           = 0
testLedger ow .fun ow' ow''  = error (strErr "Undefined")


-- To run IO
main  :  ConsoleProg 
main  =  run  (mainBody testLedger 0)
