//
//  Sockets.TCP.Connection+IP.swift
//  swift-sockets-ip-address
//

public import IO
public import IP_Address
public import Kernel
public import Sockets

extension Sockets.TCP.Connection {
    /// Connects to either canonical IP family while preserving the selected
    /// address value. Ordering and racing policy remain with the caller.
    public static func connect(
        to address: IP.Address,
        port: UInt16,
        io: IO<Sockets.Capabilities>
    ) async throws(Sockets.Error) -> sending Sockets.TCP.Connection {
        switch address {
        case .v4(let address):
            return try await connect(
                to: Kernel.Socket.Address.IPv4(ip: address, port: port),
                io: io
            )
        case .v6(let address):
            return try await connect(
                to: Kernel.Socket.Address.IPv6(ip: address, port: port),
                io: io
            )
        }
    }
}
