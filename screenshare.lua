-- Get streamer IP
write("Enter streamer IP: ")
local ip = read()

-- Connect to streamer
http.websocketAsync(ip)
local event, url, handle
repeat
    event, url, handle = os.pullEvent("websocket_success")
until url == ip
print("Connected to ".. url)

-- Setup termination handling
local ok, err = pcall(function()
    -- Draw frame
    function calcScreen(screen, stream)
        handle.send(stream)
        local response, _ = handle.receive()
        response = textutils.unserialiseJSON(response)
        for line = 1, 40 do
            for pixel = 1, 82 do
                local c = response[line]:sub(pixel, pixel)
                screen.setCursorPos(pixel, line)
                screen.setBackgroundColor(colors.fromBlit(tostring(c)))
                screen.write(string.char(0))
            end
        end
    end

    -- Main Setup
    local detectedScreen = peripheral.find("monitor")
    write("Enter name of stream quadrant: ")
    local selectedStream = read()
    while true do
        calcScreen(detectedScreen, selectedStream)
    end
end)
if handle then handle.close() end
assert(ok, err)
