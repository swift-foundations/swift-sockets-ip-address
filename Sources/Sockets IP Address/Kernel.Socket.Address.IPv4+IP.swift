//
//  Kernel.Socket.Address.IPv4+IP.swift
//  swift-sockets-ip-address
//

public import IP_Address
public import Kernel
public import Sockets

extension Kernel.Socket.Address.IPv4 {
    /// Creates a typed socket address from the canonical RFC 791 address.
    public init(ip: IPv4.Address, port: UInt16 = 0) {
        // swift-linter:disable:next raw value access
        // REASON: this extension initializer IS the typed-conversion boundary
        // between the RFC 791 host-order arithmetic form and ISO 9945's
        // network-order storage; `IPv4.Address` exposes no network-order
        // accessor, so the brand's rawValue is consumed exactly here.
        let address: UInt32 = ip.rawValue
        self.init(address: address.bigEndian, port: port)
    }

    /// The canonical RFC 791 address in host-order arithmetic form.
    public var ip: IPv4.Address {
        IPv4.Address(rawValue: UInt32(bigEndian: address))
    }
}
