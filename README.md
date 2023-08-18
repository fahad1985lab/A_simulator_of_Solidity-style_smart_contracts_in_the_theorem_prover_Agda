# A simulator of Solidity-style smart contracts in the theorem prover Agda

## Code in Agda
* All Agda Code
  [Agdacode](/Agdacode/) 

  
* The file  [guidelines.agda](Agdacode/guidelines.agda/) shows the code in the order as it appears in the paper.

## Html Version of Agda code 
* Allows to preview the Agda code without Agda installation: [html](https://htmlpreview.github.io/?https://github.com/fahad1985lab/A_simulator_of_Solidity-style_smart_contracts_in_the_theorem_prover_Agda/blob/main/Html/guidelines.html). In order to render it in your browser, you need to download it first and then load the downloaded file Html/guidelines.html into your browser. Location of files: [html](/Html/guidelines.html)

## Authors and Licence
* A simulator of Solidity-style smart contracts in the theorem prover Agda - by 
 Fahad F. Alhabardi and [Anton Setzer](https://www.cs.swan.ac.uk/~csetzer/).
 
 
* Licensed under a [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html).


## Appendix to a simulator of Solidity-style smart contracts in the
theorem prover Agda:

* In the appendix, we explain the translation of Solidity into Agda [link](https://github.com/fahad1985lab/A_simulator_of_Solidity-style_smart_contracts_in_the_theorem_prover_Agda/blob/main/Appendix_to_a_simulator_of_Solidity-style_smart_contracts_in_the_theorem_prover_Agda.pdf).

* Counter example of translation Solidity into Agda in simple simulator [link](https://github.com/fahad1985lab/A_simulator_of_Solidity-style_smart_contracts_in_the_theorem_prover_Agda/blob/main/Agdacode/Complex-Model/example/solidityToagdaIncomplexmodel-votingexample.agda). 

* Voting example of translation Solidity into Agda in complex simulator [link](https://github.com/fahad1985lab/A_simulator_of_Solidity-style_smart_contracts_in_the_theorem_prover_Agda/blob/main/Agdacode/Simple-Model/example/solidityToagdaInsimplemodel-counterexample.agda). 


## Previous publications:
 
* The first paper ( Verification of Bitcoin Script in Agda Using Weakest Preconditions for Access Control
) is available here: [link](https://doi.org/10.4230/LIPIcs.TYPES.2021.1) and [doi](https://doi.org/10.4230/LIPIcs.TYPES.2021.1).
 
* The second paper (Verifying Correctness of Smart Contracts with Conditionals) is available here: [link](https://ieeexplore.ieee.org/abstract/document/10087054) and [doi](http://dx.doi.org/10.1109/iGETblockchain56591.2022.10087054).
 
## Previous git repositories:
 
* The git repository for the first publication is available here: [link](https://github.com/fahad1985lab/Smart--Contracts--Verification--With--Agda)

* The git repository for the second publication is available here: [link](https://github.com/fahad1985lab/Verifying--Correctness--of-Smart--Contracts--with--Conditionals)
 

## Demonstration of Blockchain Simulators: 

* Simple Blockchain simulator (a simple counter).\
  The screenshot below will execute the following commands in sequence:

    * Select: `Option 1`, to execute at address `1` function `counter` with argument `1`.\
      The result will be `nat 0` (returning the content of the variable counter). 
    * Select: `Option 2`, to check a balance at address `1`.\
      This will return the balance at address `1`, which is 40 wei.
    * Select: `Option 3`, to change the calling address by entering a new calling address, `1`\
      and then calling the `increment` function with argument `0`.\
      The result will be `nat 1`.
    * Select: `Option 1`, to check function `counter` at address `1` after incrementing our counter.\
      The result will be `nat 1`.

![simple](https://github.com/fahad1985lab/A_simulator_of_Solidity-style_smart_contracts_in_the_theorem_prover_Agda/assets/77390330/3091812b-4412-4be7-8bef-ecc2fd5de0fb)



* Complex Blockchain simulator (basic voting example)\
  The screenshot below will execute the following commands in sequence:

    * Select: `Option 3`, to change the calling address to address `1`\
      	      and execute function addVoter with argument `nat 1` at address `1`.\
	      This will add voter `1`.  
    * Select: `Option 4`, to update the gas limit to `30` wei.
    * Select: `Option 5`, to check the gas limit after updating.\
      	      The result will be `30` wei.  
    * Select: `Option 6`, to check the pure function `checkVoter` with argument `nat 1`.\
      	      This returns `theMsg 1` for true.
    * Select: `Option 6`, to check the counter (number of votes), and we get `theMsg 0`,\
      	      i.e. number of votes is 0.
    * Select: `Option 1`, to call from address 1 function `vote` with argument `nat 1`.\
      	      This will return `nat 1`.
    * Select: `Option 6`, to check the pure function `checkVoter` with argument `nat 1`.\
      	      We get `theMsg 0` for false,\
	      which means voter 1 is (having voted) no longer allowed to vote. 
    * Select: `Option 6`, to check the pure function `counter`,\
      	      and we get `theMsg 1`, i.e. number of votes is 1.
    * Select: `Option 1`, to try to vote again (argument `nat 1`),\
      	      and this time, we get an error, because voter 1 is no longer allowed to vote.

![complex](https://github.com/fahad1985lab/A_simulator_of_Solidity-style_smart_contracts_in_the_theorem_prover_Agda/assets/77390330/840fb1a9-8d17-491a-ab62-c6ad324b4e80)
  



