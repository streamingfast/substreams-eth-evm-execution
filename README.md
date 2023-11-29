## Substreams Ethereum EVM Execution

This repository show cases embedding an EVM (https://github.com/rust-ethereum/evm) directly inside a Substreams WASM package to execute some "calls" directly against the contract's byte code and the block's storage changes.

The experiment conducted in this repository is to extract `name()`, `symbol()` and `decimals()` straight at contract creation without having to rely on RPC calls to gather the information.

In a nutshell, we extract all contract creations from the block. From the contract's creation call, we extract all the storage changes.

Once we have `(<byte_code>, Vec<StorageChange>)`, we initiate the EVM with the byte code and do our `name()`, `symbol()` and `decimals()` call directly, extracting information from the contract without relying on RPC calls.

### Usage

```bash
make stream
```

Which should give you something like:

```json
...
map_blocks: log: Machine active opcode is RETURN
map_blocks: log: EVM returned gracefully 0000000000000000000000000000000000000000000000000000000000000006
{
  "@module": "map_blocks",
  "@block": 4634748,
  "@type": "contract.v1.Contracts",
  "@data": {
    "contracts": [
      {
        "name": "Tether USD",
        "symbol": "USDT",
        "decimals": "6"
      }
    ]
  }
}
```

### Caveats

For now, we accumulate only the storage changes on the contract's creation call. We could actually use the full transaction storage changes. We could even think about getting all storage changes for the block for those contract(s). However for blocks, it might be too much. To reduce memory constraints, we could use references to storage bytes so that should be manageable.

Proxy contracts initialized across multiple blocks is not going to work with this method for now. One workaround would be to track the "initialize" method (I imagine multiple names could be used as the initialize method) and then do the same idea again.
