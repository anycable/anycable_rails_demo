class BasicSocket
  def initialize(...)
    raise NotImplementedError, "Socket is not supported in WASM"
  end
end

class Socket < BasicSocket
end

class IPSocket < Socket
end

class TCPSocket < Socket
end
