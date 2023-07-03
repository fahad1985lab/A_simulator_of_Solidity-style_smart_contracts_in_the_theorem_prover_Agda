open import constantparameters


module guidelines (param : ConstantParameters) where


-- This file is guidelines for the code contained in the paper.
-- The authors:  Fahad Alhabardi and Anton Setzer
-- The title of the paper: A simulator of Solidity-style smart contracts in the theorem prover Agda
-- All files have been checked and worked


-- Sect 1 INTRODUCTION

-- Sect 2 RELATED WORK

-- Sect 3 BACKGROUND

--- Subsection 3.1 A brief introduction to the Agda theorem prover

open import Simple-Model.library-simple-model.basicDataStructureWithSimpleModel
open import Simple-Model.IOledger.IOledger-counter

--- Subsection 3.2 Interface Library
open import interface.Base
open import interface.Console 



-- Sect 4 A SIMULATOR OF SOLIDITY-STYLE SMART CONTRACTS IN AGDA

--- Subsection 4.1 Simulator of the simple model

-- A count example
open import Simple-Model.example.examplecounter

-- Interactive program in Agda for simple simulator
open import Simple-Model.IOledger.IOledger-counter

-- Ledger
open import Simple-Model.ledgerversion.Ledger-Simple-Model


-- library for simple model
open import Simple-Model.library-simple-model.basicDataStructureWithSimpleModel



--- Subsection 4.2 Simulator of the complex model

-- A voting example

open import Complex-Model.example.votingexample-complex

-- Interactive program in Agda for complex simulator

open import Complex-Model.IOledger.IOledger-votingexample

--Ledger

open import Complex-Model.ledgerversion.Ledger-Complex-Model
open import Complex-Model.ledgerversion.Ledger-Complex-Model-improved-non-terminate

-- commands and responses
open import Complex-Model.ccomand.ccommands-cresponse


-- Sect 5 CONCLUSION AND FUTURE WORK
