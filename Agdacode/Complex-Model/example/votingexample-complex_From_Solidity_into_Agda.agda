open import constantparameters

module Complex-Model.example.votingexample-complex_From_Solidity_into_Agda  where
open import Data.List
open import Data.Bool.Base
open import Agda.Builtin.Unit
open import Data.Product renaming (_,_ to _,,_ )
open import Data.Maybe hiding (_>>=_)
open import Data.Nat.Base
open import Data.Nat.Show
open import Data.Fin.Base hiding (_+_; _-_)
import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_ ; refl ; sym ; cong)
open import Agda.Builtin.Nat using (_-_; _*_)


--our work
open import  libraries.natCompare
open import Complex-Model.ledgerversion.Ledger-Complex-Model exampleParameters
open import Complex-Model.ccomand.ccommands-cresponse
open import basicDataStructure
open import interface.ConsoleLib
open import libraries.IOlibrary
open import Complex-Model.IOledger.IOledger-votingexample
open import libraries.Mainlibrary



--define increment aux
incrementAux : MsgOrError → SmartContract Msg
incrementAux (theMsg (nat n)) = (exec (updatec "counter" (λ _ → λ msg → theMsg (nat (suc n))) λ oldFun oldcost msg → 1)
                                                          (λ n → 1)) λ x → return 1 (nat (suc n))
incrementAux ow = error (strErr "counter returns not a number") ⟨ 0 >> 0 ∙ "increment" [ (nat 0) ]⟩

--add voter function
addVoterAux : Msg → (Msg → MsgOrError) → Msg → MsgOrError
addVoterAux (nat newaddr) oldCheckVoter (nat addr) =
    if    newaddr ≡ᵇ addr
    then  theMsg (nat 1) -- return 1 for true
    else  oldCheckVoter (nat addr)
addVoterAux ow ow' ow'' =
    err (strErr " You cannot add voter ")


--delete voter function
deleteVoterAux : Msg → (Msg → MsgOrError) → (Msg → MsgOrError)
deleteVoterAux (nat newaddr) oldCheckVoter (nat addr) =
     if newaddr ≡ᵇ addr
     then theMsg (nat 0) --return 0 for true (means delete)  
     else oldCheckVoter (nat addr)
deleteVoterAux ow ow' ow'' = err (strErr " You cannot delete voter ")



mysuc : MsgOrError → MsgOrError
mysuc (theMsg (nat n)) = theMsg (nat (suc n))
mysuc (theMsg  ow)= err (strErr " You cannot increment ")
mysuc ow = ow


-- incrementAux for many candidates
incrementcandidates : ℕ → (Msg → MsgOrError) → Msg → MsgOrError
incrementcandidates candidateVotedFor oldCounter (nat candidate) = if candidateVotedFor ≡ᵇ candidate
                                                                   then mysuc (oldCounter (nat candidate))
                                                                   else oldCounter (nat candidate)
incrementcandidates ow ow' ow'' = err (strErr " You cannot delete voter ")


incrementAux1 : MsgOrError → SmartContract Msg
incrementAux1 (theMsg (nat candidate)) = (exec (updatec "counter" (incrementcandidates candidate) λ oldFun oldcost msg → 1)
                                                          (λ n → 1)) λ x → return 1 (nat candidate)
incrementAux1 ow = error (strErr "counter returns not a number") ⟨ 0 >> 0 ∙ "increment" [ (nat 0) ]⟩


-- the voteAux function, we use it in case to check voter is allowed to vote or not
-- We have four cases as follows:

-- in case nat 0 it will return error and not allow to vote
-- in case suc (nat 1) it will allow to vote and it will call incrementAux to increment the counter
-- in case (nat (suc (suc _)))), it will return an error because the number not a boolean 0 (false) or 1 (true).
-- in case the result of checkvoter not a number, it will return an error message.

voteAux : Address → MsgOrError → (candidate : Msg) → SmartContract Msg
voteAux addr (theMsg (nat 0)) candidate  = error (strErr "The voter is not allowed to vote")
                                           ⟨ 0 >> 0 ∙ "Voter is not allowed to vote" [ nat 0 ]⟩
                                           
voteAux addr (theMsg (nat 1)) candidate = exec (updatec "checkVoter" (deleteVoterAux (nat addr)) λ oldFun oldcost msg → 1)
                                          (λ _ → 1) (λ x → (incrementAux1 (theMsg candidate)))
                                          
voteAux addr (theMsg (nat (suc (suc _)))) candidate = exec (raiseException 1 "checkVoter doesn't return Bool")(λ _ → 1)(λ ())

voteAux addr (theMsg ow) candidate =  error (strErr "checkvoter doesn't return number")
                                      ⟨ 0 >> 0 ∙ "Voter is not allowed to vote" [ nat 0 ]⟩

voteAux addr (err x) candidate =  error x  ⟨ 0 >> 0 ∙ (error2Str x) [ nat 0 ]⟩





-- Example
testLedger : Ledger
testLedger 1 .amount = 100
testLedger 1 .purefunction "counter" msg     = theMsg (nat 0)
testLedger 1 .purefunction "checkVoter" msg  = theMsg (nat 0)
testLedger 1 .purefunctionCost "checkVoter" msg = 1
testLedger 1 .fun "addVoter" msg    = exec (updatec "checkVoter" (addVoterAux msg) λ oldFun oldcost msg → 1)
                                      (λ _ → 1) λ _ → return 1 msg
testLedger 1 .fun "deleteVoter" msg = exec (updatec "checkVoter" (deleteVoterAux msg) λ oldFun oldcost msg → 1)
                                      (λ _ → 1) λ _ → return 1 msg
testLedger 1 .fun "vote" msg        =  exec callAddrLookupc  (λ _ → 1)
                                       λ addr → exec (callPure addr "checkVoter" (nat addr))
                                       (λ _ → 1) λ checkvoterResult → voteAux addr checkvoterResult msg

--- The amount for address 0 and 3
testLedger 0 .amount   = 100
testLedger 3 .amount   = 100

-- For other addresses
testLedger ow .amount  = 0
testLedger ow .fun ow' ow'' = error (strErr "Undefined") ⟨ ow >> ow ∙ ow' [ ow'' ]⟩
testLedger ow .purefunction ow' ow'' = err (strErr "Undefined")
testLedger ow .purefunctionCost ow' ow'' = 1

--main program IO

main  : ConsoleProg
main  = run (mainBody (⟨ testLedger ledger, 0 initialAddr, 20 gas⟩))
