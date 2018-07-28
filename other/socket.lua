local component = require("component")

local timeout_value = 5

local socket = {}

function socket.version()
    return 3
end

function socket.gettime()
    -- KEEP_ALIVE_TIME    =   60  -- seconds (maximum is 65535)
    -- local activity_timeout = self.last_activity + MQTT.client.KEEP_ALIVE_TIME
    -- self.last_activity = MQTT.Utility.get_time()
    return os.time()
end

function socket.select()
    -- read_sockets, write_sockets, error_state =
      -- socket.select({socket_client}, nil, 0.001)
    --if (#read_sockets == 0) then ready = false end
    return {1}, 0, 0
end

function socket.connect(hostname, port)
    local connection = socket.connection.create(hostname, port)
    -- -- print("timeout_value", timeout_value)
    -- local time_max = timeout_value
    -- while not connection._connection.finishConnect() do
        -- if time_max <= 0 then error("timeout") end
        -- time_max = time_max - 0.1
        -- os.sleep(0.1)
    -- end
    return connection
end

socket.connection = {}
socket.connection.__index = socket.connection
    
function socket.connection.create(hostname, port)
    local connection = {}
    setmetatable(connection, socket.connection)
    connection.hostname = hostname
    connection.port = port
    connection._connection = component.internet.connect(hostname, port)
    return connection
end

function socket.connection:isConnected()
    return not self._connection.finishConnect()
end

function socket.connection:settimeout(value)
    assert(value)
    -- print("self", self)
    -- print("settimeout", value)
    timeout_value = value
end

function socket.connection:send(message)
    --local status, error_message = self.socket_client:send(message)
    -- return 
    local bytesWritten = self._connection.write(message)
    if #message ~= bytesWritten then
        error_message = "bytesWritten:"..tostring(bytesWritten)
        return nil, error_message
    else
        return bytesWritten, nil
    end
    
end

function socket.connection:receive(message)
    --response, error_message, buffer = socket_client:receive("*a")
    local buffer = self._connection.read()
    return nil, nil, buffer
end

function socket.connection:close()
    self._connection.close()
end

return socket