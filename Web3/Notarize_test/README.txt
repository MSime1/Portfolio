Deploy a notarize contract.
Contract Deployed on Etherscan Sepolia network at 0x848393ed2A8aF50b929833b0F7099DAF0008c4DC.
Contract already verified.

___________

Deploy:

1) add sepolia network in truffle config:

  sepolia : {
      network_id: 11155111,       // Sepolia's id
      confirmations: 2,    // # of confirmations to wait between deployments. (default: 0)
      timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
      skipDryRun: true     // S
    }

2) add the plugins in truffle config:

  plugins: [
    'truffle-plugin-verify',
    'solidity-coverage',
    'truffle-contract-size'
  ],

3) add the etherscan apikey:

 api_keys: {
    etherscan: "ENTER_THE_API",
  },

4) Run "truffle dashboard" on another terminal

5) Run "truffle deploy --network dashboard" to deploy the contract and pay the transaction fees.
   The dashboard will connect to the metamask and pay

6) Run "truffle run verify --network sepolia CONTRACT_NAME@CONTRACT_ADDRESS" to verify amd use the contract


If the constructor had parameters add with --forceConstructorArg string: META_DATA_OF_THE_ARGS



Deploy a notarize contract.
Contract Deployed on Etherscan Sepolia network at 0x848393ed2A8aF50b929833b0F7099DAF0008c4DC.
Contract already verified.

___________

Deploy:

1) add sepolia network in truffle config:

  sepolia : {
      network_id: 11155111,       // Sepolia's id
      confirmations: 2,    // # of confirmations to wait between deployments. (default: 0)
      timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
      skipDryRun: true     // S
    }

2) add the plugins in truffle config:

  plugins: [
    'truffle-plugin-verify',
    'solidity-coverage',
    'truffle-contract-size'
  ],

3) add the etherscan apikey:

 api_keys: {
    etherscan: "ENTER_THE_API",
  },

4) Run "truffle dashboard" on another terminal

5) Run "truffle deploy --network dashboard" to deploy the contract and pay the transaction fees.
   The dashboard will connect to the metamask and pay

6) Run "truffle run verify --network sepolia CONTRACT_NAME@CONTRACT_ADDRESS" to verify amd use the contract


If the constructor had parameters add with --forceConstructorArg string: META_DATA_OF_THE_ARGS





