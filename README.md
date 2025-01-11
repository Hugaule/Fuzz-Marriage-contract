# Smart Contract Security: Fuzz Testing with Echidna  

This repository demonstrates the use of **Echidna**, a fuzz testing tool for Ethereum smart contracts, to validate and secure a Solidity contract (`Person.sol`) modeling personal attributes and marriage relationships.  

## 🚀 Features  

- **Smart Contract Logic**:  
  - Handles marriage, divorce, aging, and subsidy calculations.  
  - Ensures symmetry in marriage and prevents invalid marriages.  
  - Dynamically adjusts state subsidies based on age and marital status.  

- **Key Invariants Tested**:  
  1. Marriage symmetry (bidirectional relationships).  
  2. No null, self, or multiple marriages.  
  3. Correct subsidy calculations based on age and marital status.  

## 🛠️ Setup  

1. Clone the repository:  
   ```bash
   git clone https://github.com/your-username/smart-contract-fuzz-testing.git
   cd smart-contract-fuzz-testing
   ```  
2. Run Echidna with Docker and the trailofbits image:  
   ```bash
   docker run -it -v $(pwd):/src trailofbits/echidna /bin/bash
   solc-select install 0.8.28
   solc-select use 0.8.28
   echidna-test /src/PersonWrapper.sol --contract PersonWrapper
   ```    

- **Hugo Le Clainche**   
