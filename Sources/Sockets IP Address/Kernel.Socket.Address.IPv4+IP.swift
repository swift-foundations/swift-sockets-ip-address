public import IP_Address
public import Kernel
import Sockets

extension Kernel.Socket.Address.IPv4 {

    public init(ip: IPv4.Address, port: UInt16 = 0) {
        self.init(address: ip.bigEndian, port: port)
    }

    public var ip: IPv4.Address {
        IPv4.Address(rawValue: UInt32(bigEndian: address))
    }
}
