//
//  Sockets.IP.Address.Tests.swift
//  swift-sockets-ip-address
//

import IO
import Kernel
import Sockets_IP_Address
import Testing

@Suite(.serialized)
struct `Sockets IP Address Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite(.serialized) struct Integration {}
}

extension `Sockets IP Address Tests`.Unit {
    @Test
    func `IPv4 conversion preserves address and port`() {
        let ip = IPv4.Address(rawValue: 0xc000_0201)
        let socket = Kernel.Socket.Address.IPv4(ip: ip, port: 443)

        #expect(socket.ip == ip)
        #expect(socket.port == 443)
    }

    @Test
    func `IPv6 conversion preserves address and metadata`() {
        let ip = IPv6.Address(0x2001, 0x0db8, 0, 1, 2, 3, 4, 5)
        let socket = Kernel.Socket.Address.IPv6(
            ip: ip,
            port: 8443,
            flowInfo: 7,
            scopeId: 9
        )

        #expect(socket.ip == ip)
        #expect(socket.port == 8443)
        #expect(socket.flowInfo == 7)
        #expect(socket.scopeId == 9)
    }
}

extension `Sockets IP Address Tests`.Integration {
    @Test
    func `IPv4 sum connects through the typed socket adapter`() async {
        let serverIO: IO<Sockets.Capabilities> = .blocking()
        let clientIO: IO<Sockets.Capabilities> = .blocking()
        let listener: Sockets.TCP.Listener
        let port: UInt16
        do throws(Sockets.Error) {
            listener = try Sockets.TCP.Listener.blocking(
                address: Kernel.Socket.Address.IPv4.loopback(port: 0),
                io: serverIO
            )
            port = try await listener.port()
        } catch {
            Issue.record("Listener setup failed: \(error)")
            return
        }

        let accepted = Task { () -> Kernel.Socket.Address.Family? in
            do throws(Sockets.Error) {
                return try await acceptAndClose(listener)
            } catch {
                Issue.record("Accept side failed: \(error)")
                return nil
            }
        }
        do throws(Sockets.Error) {
            let connection = try await Sockets.TCP.Connection.connect(
                to: .v4(.loopback),
                port: port,
                io: clientIO
            )
            #expect(connection.peer.family == .inet)
            await connection.close()
        } catch {
            Issue.record("Connect side failed: \(error)")
        }
        #expect(await accepted.value == .inet)
    }

    @Test
    func `IPv6 sum connects through the typed socket adapter`() async {
        let serverIO: IO<Sockets.Capabilities> = .blocking()
        let clientIO: IO<Sockets.Capabilities> = .blocking()
        let listener: Sockets.TCP.Listener
        let port: UInt16
        do throws(Sockets.Error) {
            listener = try Sockets.TCP.Listener.blocking(
                address: Kernel.Socket.Address.IPv6.loopback(port: 0),
                io: serverIO
            )
            port = try await listener.port()
        } catch {
            Issue.record("Listener setup failed: \(error)")
            return
        }

        let accepted = Task { () -> Kernel.Socket.Address.Family? in
            do throws(Sockets.Error) {
                return try await acceptAndClose(listener)
            } catch {
                Issue.record("Accept side failed: \(error)")
                return nil
            }
        }
        do throws(Sockets.Error) {
            let connection = try await Sockets.TCP.Connection.connect(
                to: .v6(.loopback),
                port: port,
                io: clientIO
            )
            #expect(connection.peer.family == .inet6)
            await connection.close()
        } catch {
            Issue.record("Connect side failed: \(error)")
        }
        #expect(await accepted.value == .inet6)
    }
}

private func acceptAndClose(
    _ listener: Sockets.TCP.Listener
) async throws(Sockets.Error) -> Kernel.Socket.Address.Family {
    let connection = try await listener.accept()
    let family = connection.peer.family
    await connection.close()
    return family
}
