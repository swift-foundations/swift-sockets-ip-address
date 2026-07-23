# swift-sockets-ip-address

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Canonical IP address bindings for swift-sockets — connect and bind with `IP.Address`, `IPv4.Address`, and `IPv6.Address` values instead of raw byte-order integers.

---

## Quick Start

Connect over either IP family with one call. The `IP.Address` sum carries the family, so the adapter selects the matching socket-address form — no manual byte-order conversion and no per-family overload juggling at the call site:

```swift
import Sockets_IP_Address

let io: IO<Sockets.Capabilities> = .blocking()

let connection = try await Sockets.TCP.Connection.connect(
    to: .v4(.loopback),
    port: 443,
    io: io
)

await connection.close()
```

Typed address construction replaces manual `bigEndian` handling:

```swift
import Sockets_IP_Address

// Without this package: Kernel.Socket.Address.IPv4(address: UInt32(0xc000_0201).bigEndian, port: 443)
let socket = Kernel.Socket.Address.IPv4(ip: IPv4.Address(rawValue: 0xc000_0201), port: 443)
let ip: IPv4.Address = socket.ip  // round-trips in host-order arithmetic form
```

---

## Installation

Add swift-sockets-ip-address to your Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/swift-foundations/swift-sockets-ip-address.git", branch: "main")
]
```

Add the product to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "Sockets IP Address", package: "swift-sockets-ip-address")
    ]
)
```

### Requirements

- Swift 6.3+
- macOS 26+ / iOS 26+ / tvOS 26+ / watchOS 26+ / visionOS 26+

---

## Architecture

Single module (`Sockets IP Address`) that re-exports both bases and adds the conversions between them:

| Surface | Role |
|---------|------|
| `Kernel.Socket.Address.IPv4.init(ip:port:)` / `.ip` | Round-trip between the socket form and the canonical RFC 791 address |
| `Kernel.Socket.Address.IPv6.init(ip:port:flowInfo:scopeId:)` / `.ip` | Round-trip between the socket form and the canonical RFC 4291 address |
| `Sockets.TCP.Connection.connect(to:port:io:)` | Family-dispatching connect over the `IP.Address` sum |

Ordering and racing policy for multi-address connect attempts remain with the caller.

---

## Community

<!-- BEGIN: discussion -->
*Discussion thread will be created at first public release.*
<!-- END: discussion -->

---

## License

Apache 2.0. See [LICENSE.md](LICENSE.md) for details.
