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
        self.init(address: ip.bigEndian, port: port)
    }

    /// The canonical RFC 791 address in host-order arithmetic form.
    public var ip: IPv4.Address {
        IPv4.Address(rawValue: UInt32(bigEndian: address))
    }
}
