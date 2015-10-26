
local ffi = require("ffi")
local bit = require("bit")
local band = bit.band

local s2n = require("s2n")

ffi.cdef[[
struct pollfd {
    int   fd;         /* file descriptor */
    short events;     /* requested events */
    short revents;    /* returned events */
};
]]

local POLLIN     = 0x0001;
local POLLPRI    = 0x0002;
local POLLOUT    = 0x0004;


local function echo(conn, sockfd)


    local success, err = conn:negotiate();
    if not success then
        error(err, s2n_connection_get_alert(conn));
    end

    -- print some meta information about the connection
    print("server name: ", conn:serverName());
    print("app protocol: ", conn:applicationProtocol())
    print("client hello Version: ", conn:clientHelloVersion())
    print("client Version: ", conn:clientProtocolVersion())
    print("server Version: ", conn:serverProtocolVersion())
    print("actual Version: ", conn:actualProtocolVersion())

--[[
    uint32_t length;
    const uint8_t *status = s2n_connection_get_ocsp_response(conn, &length);
    if (status && length > 0) {
        fprintf(stderr, "OCSP response received, length %d\n", length);
    }

    printf("Cipher negotiated: %s\n", s2n_connection_get_cipher(conn));
--]]

    -- Act as a simple proxy between stdin and the SSL connection
    local readers = ffi.new("struct pollfd[2]")

    readers[0].fd = sockfd;
    readers[0].events = POLLIN;
    readers[1].fd = STDIN_FILENO;
    readers[1].events = POLLIN;
    local buffer = ffi.new("char[10240]");

    while (ffi.C.poll(readers, 2, -1) > 0) do
        local bytes_read, bytes_written = 0;

        if band(readers[0].revents, POLLIN) then
            repeat
                bytes_read = s2n_recv(conn, buffer, 10240, &more);
                if (bytes_read == 0) {
                    /* Connection has been closed */
                    s2n_connection_wipe(conn);
                    return 0;
                }
                if (bytes_read < 0) {
                    fprintf(stderr, "Error reading from connection: '%s' %d\n", s2n_strerror(s2n_errno, "EN"), s2n_connection_get_alert(conn));
                    exit(1);
                }
                bytes_written = write(STDOUT_FILENO, buffer, bytes_read);
                if (bytes_written <= 0) {
                    fprintf(stderr, "Error writing to stdout\n");
                    exit(1);
                }
            until (not more);
        end

        if band(readers[1].revents, POLLIN) then
            local bytes_available;
            if (ioctl(STDIN_FILENO, FIONREAD, &bytes_available) < 0) then
                bytes_available = 1;
            end

            if (bytes_available > sizeof(buffer)) then
                bytes_available = sizeof(buffer);
            end

            -- Read as many bytes as we think we can
            bytes_read = read(STDIN_FILENO, buffer, bytes_available);
            if (bytes_read < 0) then
                fprintf(stderr, "Error reading from stdin\n");
                error(1);
            end

            if (bytes_read == 0) then
                -- Exit on EOF
                return 0;
            end

            local buf_ptr = buffer;
            repeat
                bytes_written, err = conn:send(buf_ptr, bytes_available, &more);
                if (bytes_written < 0) then
                    fprintf(stderr, "Error writing to connection: '%s'\n", s2n_strerror(s2n_errno, "EN"));
                    error(1);
                end

                bytes_available -= bytes_written;
                buf_ptr += bytes_written;
            until bytes_available=0 and more[0]==0
        end
    end

    return 0;
end

return echo
