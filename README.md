## Go KDChain

Official golang implementation of KDChain

## Building the source

Building gkdchain requires both a Go (version 1.7 or later) and a C compiler.
You can install them using your favourite package manager.
Once the dependencies are installed, run

    make gkdchain

or, to build the full suite of utilities:

    make all

## Executables

The go-kdchain project comes with several wrappers/executables found in the `cmd` directory.

## Running gkdchain

### Full node on the main KDchain network

By far the most common scenario is people wanting to simply interact with the KDchain network:
create accounts; transfer funds; deploy and interact with contracts. For this particular use-case
the user doesn't care about years-old historical data, so we can fast-sync quickly to the current
state of the network. To do so:

```
$ gkdchain console
```

This command will:

 * Start gkdchain in fast sync mode (default, can be changed with the `--syncmode` flag), causing it to
   download more data in exchange for avoiding processing the entire history of the KDChain network,
   which is very CPU intensive.
 * Start up gkdchain's built-in interactive [JavaScript console],
   (via the trailing `console` subcommand) through which you can invoke all official [`web3` methods]
   as well as gkdchain's own [management APIs].
   This too is optional and if you leave it out you can always attach to an already running gkdchain instance
   with `gkdchain attach`.

### Full node on the KDChain test network

Transitioning towards developers, if you'd like to play around with creating KDchain contracts, you
almost certainly would like to do that without any real money involved until you get the hang of the
entire system. In other words, instead of attaching to the main network, you want to join the **test**
network with your node, which is fully equivalent to the main network, but with play-KDchain only.

```
$ gkdchain --testnet console
```

The `console` subcommand have the exact same meaning as above and they are equally useful on the
testnet too. Please see above for their explanations if you've skipped to here.

Specifying the `--testnet` flag however will reconfigure your gkdchain instance a bit:

 * Instead of using the default data directory (`~/.kdchain` on Linux for example), gkdchain will nest
   itself one level deeper into a `testnet` subfolder (`~/.kdchain/testnet` on Linux). Note, on OSX
   and Linux this also means that attaching to a running testnet node requires the use of a custom
   endpoint since `gkdchain attach` will try to attach to a production node endpoint by default. E.g.
   `gkdchain attach <datadir>/testnet/gkdchain.ipc`. Windows users are not affected by this.
 * Instead of connecting the main KDchain network, the client will connect to the test network,
   which uses different P2P bootnodes, different network IDs and genesis states.
   
*Note: Although there are some internal protective measures to prevent transactions from crossing
over between the main network and test network, you should make sure to always use separate accounts
for play-money and real-money. Unless you manually move accounts, gkdchain will by default correctly
separate the two networks and will not make any accounts available between them.*

### Full node on the Rinkeby test network

The above test network is a cross client one based on the ethash proof-of-work consensus algorithm. As such, it has certain extra overhead and is more susceptible to reorganization attacks due to the network's low difficulty / security. Go KDchain also supports connecting to a proof-of-authority based test network called [*Rinkeby*](https://www.rinkeby.io) (operated by members of the community). This network is lighter, more secure, but is only supported by go-kdchain.

```
$ gkdchain --rinkeby console
```

### Configuration

As an alternative to passing the numerous flags to the `gkdchain` binary, you can also pass a configuration file via:

```
$ gkdchain --config /path/to/your_config.toml
```

To get an idea how the file should look like you can use the `dumpconfig` subcommand to export your existing configuration:

```
$ gkdchain --your-favourite-flags dumpconfig
```

*Note: This works only with gkdchain v1.6.0 and above.*

#### Docker quick start

One of the quickest ways to get KDchain up and running on your machine is by using Docker:

```
docker run -d --name kdchain-node -v /Users/alice/kdchain:/root \
           -p 8545:8545 -p 31409:31409 \
           kdchain/client-go
```

This will start gkdchain in fast-sync mode with a DB memory allowance of 1GB just as the above command does.  It will also create a persistent volume in your home directory for saving your blockchain as well as map the default ports. There is also an `alpine` tag available for a slim version of the image.

Do not forget `--rpcaddr 0.0.0.0`, if you want to access RPC from other containers and/or hosts. By default, `gkdchain` binds to the local interface and RPC endpoints is not accessible from the outside.

### Programatically interfacing gkdchain nodes

As a developer, sooner rather than later you'll want to start interacting with gkdchain and the KDchain
network via your own programs and not manually through the console. To aid this, gkdchain has built-in
support for a JSON-RPC based APIs. These can be exposed via HTTP, WebSockets and IPC (unix sockets on unix based platforms, and named pipes on Windows).

The IPC interface is enabled by default and exposes all the APIs supported by gkdchain, whereas the HTTP
and WS interfaces need to manually be enabled and only expose a subset of APIs due to security reasons.
These can be turned on/off and configured as you'd expect.

HTTP based JSON-RPC API options:

  * `--rpc` Enable the HTTP-RPC server
  * `--rpcaddr` HTTP-RPC server listening interface (default: "localhost")
  * `--rpcport` HTTP-RPC server listening port (default: 8545)
  * `--rpcapi` API's offered over the HTTP-RPC interface (default: "eth,net,web3")
  * `--rpccorsdomain` Comma separated list of domains from which to accept cross origin requests (browser enforced)
  * `--ws` Enable the WS-RPC server
  * `--wsaddr` WS-RPC server listening interface (default: "localhost")
  * `--wsport` WS-RPC server listening port (default: 8546)
  * `--wsapi` API's offered over the WS-RPC interface (default: "eth,net,web3")
  * `--wsorigins` Origins from which to accept websockets requests
  * `--ipcdisable` Disable the IPC-RPC server
  * `--ipcapi` API's offered over the IPC-RPC interface (default: "admin,debug,eth,miner,net,personal,shh,txpool,web3")
  * `--ipcpath` Filename for IPC socket/pipe within the datadir (explicit paths escape it)

You'll need to use your own programming environments' capabilities (libraries, tools, etc) to connect
via HTTP, WS or IPC to a gkdchain node configured with the above flags and you'll need to speak [JSON-RPC](http://www.jsonrpc.org/specification)
on all transports. You can reuse the same connection for multiple requests!

**Note: Please understand the security implications of opening up an HTTP/WS based transport before
doing so! Hackers on the internet are actively trying to subvert KDchain nodes with exposed APIs!
Further, all browser tabs can access locally running webservers, so malicious webpages could try to
subvert locally available APIs!**

### Operating a private network

Maintaining your own private network is more involved as a lot of configurations taken for granted in
the official networks need to be manually set up.

#### Defining the private genesis state

First, you'll need to create the genesis state of your networks, which all nodes need to be aware of
and agree upon. This consists of a small JSON file (e.g. call it `genesis.json`):

```json
{
  "config": {
        "chainId": 0,
        "homesteadBlock": 0,
        "eip155Block": 0,
        "eip158Block": 0
    },
  "alloc"      : {},
  "coinbase"   : "0x0000000000000000000000000000000000000000",
  "difficulty" : "0x20000",
  "extraData"  : "",
  "gasLimit"   : "0x2fefd8",
  "nonce"      : "0x0000000000000042",
  "mixhash"    : "0x0000000000000000000000000000000000000000000000000000000000000000",
  "parentHash" : "0x0000000000000000000000000000000000000000000000000000000000000000",
  "timestamp"  : "0x00"
}
```

The above fields should be fine for most purposes, although we'd recommend changing the `nonce` to
some random value so you prevent unknown remote nodes from being able to connect to you. If you'd
like to pre-fund some accounts for easier testing, you can populate the `alloc` field with account
configs:

```json
"alloc": {
  "0x0000000000000000000000000000000000000001": {"balance": "111111111"},
  "0x0000000000000000000000000000000000000002": {"balance": "222222222"}
}
```

With the genesis state defined in the above JSON file, you'll need to initialize **every** gkdchain node
with it prior to starting it up to ensure all blockchain parameters are correctly set:

```
$ gkdchain init path/to/genesis.json
```

#### Creating the rendezvous point

With all nodes that you want to run initialized to the desired genesis state, you'll need to start a
bootstrap node that others can use to find each other in your network and/or over the internet. The
clean way is to configure and run a dedicated bootnode:

```
$ bootnode --genkey=boot.key
$ bootnode --nodekey=boot.key
```

With the bootnode online, it will display an [`enode` URL]
that other nodes can use to connect to it and exchange peer information. Make sure to replace the
displayed IP address information (most probably `[::]`) with your externally accessible IP to get the
actual `enode` URL.

*Note: You could also use a full fledged gkdchain node as a bootnode, but it's the less recommended way.*

#### Starting up your member nodes

With the bootnode operational and externally reachable (you can try `telnet <ip> <port>` to ensure
it's indeed reachable), start every subsequent gkdchain node pointed to the bootnode for peer discovery
via the `--bootnodes` flag. It will probably also be desirable to keep the data directory of your
private network separated, so do also specify a custom `--datadir` flag.

```
$ gkdchain --datadir=path/to/custom/data/folder --bootnodes=<bootnode-enode-url-from-above>
```

*Note: Since your network will be completely cut off from the main and test networks, you'll also
need to configure a miner to process transactions and create new blocks for you.*

#### Running a private miner

Mining on the public KDchain network is a complex task as it's only feasible using GPUs, requiring
an OpenCL or CUDA enabled `kdminer` instance. 

In a private network setting however, a single CPU miner instance is more than enough for practical
purposes as it can produce a stable stream of blocks at the correct intervals without needing heavy
resources (consider running on a single thread, no need for multiple ones either). To start a gkdchain
instance for mining, run it with all your usual flags, extended by:

```
$ gkdchain <usual-flags> --mine --minerthreads=1 --KDchainbase=0x0000000000000000000000000000000000000000
```

Which will start mining blocks and transactions on a single CPU thread, crediting all proceedings to
the account specified by `--KDchainbase`. You can further tune the mining by changing the default gas
limit blocks converge to (`--targetgaslimit`) and the price transactions are accepted at (`--gasprice`).

## Contribution

Thank you for considering to help out with the source code! We welcome contributions from
anyone on the internet, and are grateful for even the smallest of fixes!



