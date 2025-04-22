-- lib/Tunnel.lua (Simplified RPC tunnel)
Tunnel = {}

function Tunnel.Call(eventName, callback, ...)
    NEXFramework:Call(eventName, callback, ...)
end