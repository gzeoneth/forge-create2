# forge-create2

A CLI tool for deterministic smart contract deployment using CREATE2 opcode through Foundry.

## Overview

`forge-create2` enables deterministic contract deployment where the contract address can be calculated before deployment. This is useful for:
- Cross-chain contract deployment at the same address
- Pre-calculating contract addresses for configuration
- Deploying contracts to addresses that satisfy certain patterns

## Features

- **Deterministic Deployment**: Uses CREATE2 for predictable contract addresses
- **Smart Deployment**: Automatically detects and skips already deployed contracts
- **Contract Verification**: Built-in support for Etherscan/Arbiscan verification
- **Type Safety**: Dynamic constructor argument encoding with full ABI support
- **Complex Types**: Handles arrays, structs, tuples, and bytes
- **Security First**: No eval usage, safe argument handling, environment variable support
- **Dry Run Mode**: Preview deployment address without sending transactions
- **Production Ready**: Comprehensive error handling and informative logging

## Installation

1. Ensure you have [Foundry](https://book.getfoundry.sh/getting-started/installation) installed
2. Clone this repository
3. Make the script executable:
   ```bash
   chmod +x forge-create2
   ```

## Usage

```bash
./forge-create2 [OPTIONS] <CONTRACT>
```

### Required Options

- `--rpc-url <url>`: RPC endpoint URL (must start with http:// or https://)
- `--private-key <key>`: Private key for deployment (64 hex characters)
  - Can also use `FORGE_CREATE2_PRIVATE_KEY` environment variable

### Optional Arguments

- `--constructor-args <args>`: Constructor arguments
- `--salt <value>`: Salt value for CREATE2 (default: 0)
- `--verify`: Verify contract on Etherscan after deployment
- `--etherscan-api-key <key>`: Etherscan API key for verification
  - Can also use `ETHERSCAN_API_KEY` environment variable
- `--dry-run`: Calculate deployment address without deploying

### Contract Format

Contracts can be specified in two formats:
- `path/to/Contract.sol` - Uses the contract name from the filename
- `path/to/Contract.sol:ContractName` - Explicitly specifies the contract name

## Examples

### Simple Deployment

Deploy a contract with no constructor arguments:
```bash
./forge-create2 src/SimpleStorage.sol \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc \
  --private-key 0x...
```

### With Constructor Arguments

#### Deploy SimpleStorage (single uint256 argument)
```bash
./forge-create2 src/SimpleStorage.sol \
  --constructor-args "42" \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc \
  --private-key <YOUR_PRIVATE_KEY> \
  --salt 0x1111111111 \
  --verify \
  --etherscan-api-key <YOUR_API_KEY>
```

#### Deploy Counter (uint, bytes32, bytes32[] array)
```bash
./forge-create2 src/Counter.sol \
  --constructor-args "123 0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890 '[0x1111111111111111111111111111111111111111111111111111111111111111,0x2222222222222222222222222222222222222222222222222222222222222222]'" \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc \
  --private-key <YOUR_PRIVATE_KEY> \
  --salt 0x2222222222
```

#### Deploy ArrayConstructor (uint256[] array)
```bash
./forge-create2 src/ArrayConstructor.sol \
  --constructor-args "'[100,200,300,400,500]'" \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc \
  --private-key <YOUR_PRIVATE_KEY> \
  --salt 0x3333333333
```

#### Deploy BytesConstructor (bytes data)
```bash
./forge-create2 src/BytesConstructor.sol \
  --constructor-args "0x48656c6c6f20576f726c642066726f6d2043524541544532" \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc \
  --private-key <YOUR_PRIVATE_KEY> \
  --salt 0x4444444444
```

#### Deploy StructConstructor (struct as tuple)
```bash
./forge-create2 src/StructConstructor.sol \
  --constructor-args "'(\"Alice\",25,0x76333c6E69F8adE05A3B2b58FEf057072cB7E943,true)'" \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc \
  --private-key <YOUR_PRIVATE_KEY> \
  --salt 0x5555555555
```

### Additional Operations

#### Dry run to preview deployment address
```bash
./forge-create2 src/SimpleStorage.sol \
  --constructor-args "999" \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc \
  --salt 0xdeadbeef \
  --dry-run
```

#### Deploy without verification (faster)
```bash
./forge-create2 src/SimpleStorage.sol \
  --constructor-args "999" \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc \
  --private-key <YOUR_PRIVATE_KEY> \
  --salt 0xdeadbeef
```

#### Deploy with default salt (0)
```bash
./forge-create2 src/SimpleStorage.sol \
  --constructor-args "777" \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc \
  --private-key <YOUR_PRIVATE_KEY>
```

#### Check if already deployed (will skip deployment)
```bash
# Run the same command twice - second time will skip deployment
./forge-create2 src/SimpleStorage.sol \
  --constructor-args "42" \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc \
  --private-key <YOUR_PRIVATE_KEY> \
  --salt 0x1111111111
```

## Environment Variables

You can set these environment variables to avoid passing sensitive data via command line:
- `FORGE_CREATE2_PRIVATE_KEY` - Private key for deployment
- `ETHERSCAN_API_KEY` - API key for contract verification

## CREATE2 Factory

This tool uses the standard CREATE2 factory deployed at:
`0x4e59b44847b379578588920ca78fbf26c0b4956c`

This factory is deployed on most EVM chains at the same address.

## How CREATE2 Works

The CREATE2 address is calculated as:
```
address = keccak256(0xff ++ factory ++ salt ++ keccak256(initCode))[12:]
```

Where:
- `0xff`: Constant to prevent collisions with CREATE
- `factory`: CREATE2 factory contract address
- `salt`: 32-byte value to make the address deterministic
- `initCode`: Contract bytecode + constructor arguments

## Security Considerations

1. **Private Key Security**: 
   - Use environment variables instead of command-line arguments when possible
   - Never commit private keys to version control
   - Consider using hardware wallets or key management systems in production

2. **Salt Values**:
   - Using predictable salts may allow others to front-run your deployment
   - Consider using random salts unless deterministic addresses are required

3. **Contract Verification**:
   - Always verify contracts on Etherscan for transparency
   - Keep your Etherscan API key secure

## Testing

Run the test suite:
```bash
bash test/forge-create2.t.sh
```

## Troubleshooting

1. **"Contract already deployed"**: The contract is already deployed at the calculated address. Use a different salt to deploy to a new address.

2. **"Failed to extract bytecode"**: Ensure the contract is compiled successfully and is not abstract or has unlinked libraries.

3. **"Invalid RPC URL format"**: The RPC URL must start with `http://` or `https://`.

4. **"Invalid private key format"**: The private key must be 64 hexadecimal characters (with or without 0x prefix).

## License

MIT