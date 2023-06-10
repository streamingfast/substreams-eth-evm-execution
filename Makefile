ENDPOINT ?= mainnet.eth.streamingfast.io:443
START_BLOCK ?= 4634748
STOP_BLOCK ?= +1

.PHONY: build
build:
	cargo build --target wasm32-unknown-unknown --release

.PHONY: stream
stream: build
	substreams run -e $(ENDPOINT) substreams.yaml map_blocks -s $(START_BLOCK) -t $(STOP_BLOCK) -p "map_blocks=value2"

.PHONY: protogen
protogen:
	substreams protogen ./substreams.yaml --exclude-paths="sf/substreams,google"
