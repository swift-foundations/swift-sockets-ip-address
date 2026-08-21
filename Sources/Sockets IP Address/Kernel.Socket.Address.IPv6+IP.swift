public import IP_Address
public import Kernel
import Sockets

extension Kernel.Socket.Address.IPv6 {

    public init(
        ip: IPv6.Address,
        port: UInt16 = 0,
        flowInfo: UInt32 = 0,
        scopeId: UInt32 = 0
    ) {
        self.init(
            segments: ip.segments,
            port: port,
            flowInfo: flowInfo,
            scopeId: scopeId
        )
    }

    public var ip: IPv6.Address {
        IPv6.Address(
            segments.0,
            segments.1,
            segments.2,
            segments.3,
            segments.4,
            segments.5,
            segments.6,
            segments.7
        )
    }
}
