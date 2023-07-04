# A simulator of Solidity-style smart contracts in the theorem prover Agda

## Code in Agda
* All Agda Code
  [Agdacode](/Agdacode/) 

  
* The file  [guidelines.agda](Agdacode/guidelines.agda/) shows the code in the order it appears in the paper.

## Html Version of Agda code 
* Allows to preview the Agda code without Agda installation: [html](https://). In order to render it in your browser, you need to download it first and then load the downloaded file Html/guidelines.html into your browser. Location of files: [html](/Html/guidelines.html)

## Authors and Licence
* A simulator of Solidity-style smart contracts in the theorem prover Agda - by 
 Fahad F. Alhabardi and [Anotn Setzer](https://www.cs.swan.ac.uk/~csetzer/).
 
 
* Licensed under a [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html).
 
## Previous publications:
 
* The first paper ( Verification of Bitcoin Script in Agda Using Weakest Preconditions for Access Control
) is available at this [link](https://doi.org/10.4230/LIPIcs.TYPES.2021.1) and [doi](https://doi.org/10.4230/LIPIcs.TYPES.2021.1).
 
* The second paper (Verifying Correctness of Smart Contracts with Conditionals) is available at this [link](https://ieeexplore.ieee.org/abstract/document/10087054) and [doi](http://dx.doi.org/10.1109/iGETblockchain56591.2022.10087054).
 
## Previous git repositories:
 
* The first publication is available at this [link](https://github.com/fahad1985lab/Smart--Contracts--Verification--With--Agda)

* The second publication is available at this  [link](https://github.com/fahad1985lab/Verifying--Correctness--of-Smart--Contracts--with--Conditionals)
 

## Demonstration of Blockchain Simulators: 

* Simple Blockchain simulator (a count example):

    * Select: `Option 1`, to execute a function at address `1`, `constnum` function with argument `1`. The result will be `nat 0` (return the constant variable). 
    * Select: `Option 2`, to check a balance at address `1`. Then it will return the balance in address `1`, which is 40 wei.
    * Select: `Option 3`, to change the calling address by entering a new calling address `1`, with `increment` function with argument `0`. The result will be `nat 1`.
      
![simple](https://github.com/fahad1985lab/A_simulator_of_Solidity-style_smart_contracts_in_the_theorem_prover_Agda/assets/77390330/e79e4407-14bc-4714-ac39-f4c3ad9e3a41)



* Complex Blockchain simulator (voting example): 

    * Select: `Option 3`, to change the calling address to address `1`. Then, execute a function at address `1` by adding voter `1`.  
    * Select: `Option 4`, to update the gas limit to `30` wei.
    * Select: `Option 5`, to check the gas limit after updating. Then the result will be `30` wei.  
    * Select: `Option 6`, to check a pure function, and we got `theMsg 1`, in which we add a voter but still do not vote.
    * Select: `Option 6`, to check a counter, and we got `theMsg 0`, meaning no one votes.
    * Select: `Option 1`, to add the vote `nat 1`.
    * Select: `Option 6`, to check a pure function, and we got `theMsg 0`, which means we do not have any vote to add.
    * Select: `Option 6`, to check a counter, and we got `theMsg 1`, which means there is one vote.
    * Select: `Option 1`, to vote again with `nat 1`, and we got an error and rejected because `nat 1` has been voted before.

![complex](https://github.com/fahad1985lab/A_simulator_of_Solidity-style_smart_contracts_in_the_theorem_prover_Agda/assets/77390330/d6cb0308-4861-4ced-acc7-efb08bc6ad0c)

