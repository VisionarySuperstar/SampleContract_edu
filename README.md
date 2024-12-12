# HENLO Presale Smart Contract

Welcome to the HENLO Presale Smart Contract! This contract is designed to facilitate a secure and transparent presale process for the HENLO token, ensuring a smooth experience for both the project owner and contributors.

## 🚀 Overview

The HENLO Presale contract allows users to purchase HENLO tokens during a defined presale period. It incorporates features such as contribution limits, presale status management, and automatic handling of funds. The contract is built with security and usability in mind, leveraging best practices in smart contract development.

### Key Features

- **Token Management**: Efficiently manages contributions and token distribution throughout the presale lifecycle.
- **Presale Status Control**: The owner can activate or deactivate the presale at any time.
- **Contribution Limits**: Set minimum and maximum contribution amounts to ensure fair participation.
- **Automatic Token Distribution**: Tokens are automatically distributed to contributors upon successful purchase.
- **Ether Handling**: Accepts Ether directly for token purchases, streamlining the buying process.
- **Extendable Presale Period**: The owner can extend the presale duration as needed.

## ✔️ How to Deploy

To deploy this contract, follow these steps:

### Prerequisites

Ensure you have the following tools installed on your machine:
- Node.js
- Hardhat (for Ethereum development)

### Deployment Steps

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/VisionarySuperstar/SampleContract_edu.git
   cd henlo-presale
   ```

2. **Install Dependencies**:
   ```bash
   npm install
   ```

3. **Set Up Environment Variables**:
   Create a `.env` file in the root of your project and populate it with necessary configurations like wallet private keys and Provider API keys. For example:
   ```plaintext
   INFURA_API_KEY=your_infura_api_key
   PRIVATE_KEY=your_wallet_private_key
   ```

4. **Deploy the Contract**:
   Run the following command to deploy your contract on a chosen network (e.g., Sepolia):
   ```bash
   npx hardhat run scripts/deploy.js --network base_sepolia
   ```

5. **Verify and Interact with Your Contract**:
   After deployment, you can verify your contract on Etherscan or interact with it using tools like Remix or Web3.js.
   Or run following command
   ```bash
   npx hardhat verify --network base_sepolia contract_address [parameters]
   ```

## 💡 Usage

Once deployed, users can participate in the presale by sending Ether to the contract address. The contract will automatically handle token distribution based on the amount of Ether sent and the defined presale rate.

### Example of Buying Tokens
Users can simply send Ether to the contract to buy tokens:
You can check test file in test/test.ts
   ```bash
   npx hardhat test
   ```


## ⚠️ Security Considerations

While this contract is designed with security in mind, it is crucial to conduct thorough testing and audits before deploying on mainnet. Consider implementing additional security measures such as:

- Rate limiting on purchases.
- Time-lock mechanisms for sensitive functions.
- Comprehensive testing for edge cases.

## 📜 License

This project is licensed under the MIT License. You are free to use, modify, and distribute this project as you see fit.

## 🤝 Contributing

Contributions are welcome! If you have suggestions or improvements, please fork the repository and submit a pull request.

## 📞 Contact Information

For any inquiries or support, feel free to reach out:

- GitHub: [VisionarySuperstar](https://github.com/VisionarySuperstar)

Thank you for exploring the HENLO Presale Smart Contract! Happy deploying! 🚀
