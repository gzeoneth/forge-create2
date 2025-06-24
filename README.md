## Forge-Create2

A CLI tool for deterministic contract deployment using CREATE2 opcode via Foundry.

### Features

- Deterministic contract deployment using CREATE2
- Automatic detection of already deployed contracts (skips redundant deployments)
- Contract verification support on Etherscan/Arbiscan
- Dynamic constructor argument encoding
- Support for complex types (arrays, structs, bytes)

### Usage

```shell
$ ./forge-create2 [OPTIONS] <CONTRACT>

Options:
  --constructor-args <args>    Constructor arguments
  --rpc-url <url>             RPC endpoint URL
  --private-key <key>         Private key for deployment
  --salt <salt>               Salt for CREATE2 (default: 0)
  --verify                    Verify contract on Etherscan
  --etherscan-api-key <key>   Etherscan API key for verification
```

### Example Commands

#### 1. Deploy SimpleStorage Contract
```bash
# Deploy with initial value of 42
./forge-create2 src/SimpleStorage.sol \
  --constructor-args "42" \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc \
  --private-key <YOUR_PRIVATE_KEY> \
  --salt 0x1111111111 \
  --verify \
  --etherscan-api-key <YOUR_API_KEY>
```

#### 2. Deploy Counter Contract
```bash
# Deploy with uint, bytes32, and bytes32[] array
./forge-create2 src/Counter.sol \
  --constructor-args "123 0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890 '[0x1111111111111111111111111111111111111111111111111111111111111111,0x2222222222222222222222222222222222222222222222222222222222222222]'" \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc \
  --private-key <YOUR_PRIVATE_KEY> \
  --salt 0x2222222222 \
  --verify \
  --etherscan-api-key <YOUR_API_KEY>
```

#### 3. Deploy ArrayConstructor Contract
```bash
# Deploy with uint256[] array
./forge-create2 src/ArrayConstructor.sol \
  --constructor-args "'[100,200,300,400,500]'" \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc \
  --private-key <YOUR_PRIVATE_KEY> \
  --salt 0x3333333333 \
  --verify \
  --etherscan-api-key <YOUR_API_KEY>
```

#### 4. Deploy BytesConstructor Contract
```bash
# Deploy with bytes data (hex string)
./forge-create2 src/BytesConstructor.sol \
  --constructor-args "0x48656c6c6f20576f726c642066726f6d2043524541544532" \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc \
  --private-key <YOUR_PRIVATE_KEY> \
  --salt 0x4444444444 \
  --verify \
  --etherscan-api-key <YOUR_API_KEY>
```

#### 5. Deploy StructConstructor Contract
```bash
# Deploy with struct (tuple format: string, uint256, address, bool)
./forge-create2 src/StructConstructor.sol \
  --constructor-args "'(\"Alice\",25,0x76333c6E69F8adE05A3B2b58FEf057072cB7E943,true)'" \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc \
  --private-key <YOUR_PRIVATE_KEY> \
  --salt 0x5555555555 \
  --verify \
  --etherscan-api-key <YOUR_API_KEY>
```

### Additional Examples

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

### Environment Variables

You can set these environment variables to avoid passing sensitive data via command line:
- `FORGE_CREATE2_PRIVATE_KEY` - Private key for deployment
- `ETHERSCAN_API_KEY` - API key for contract verification
