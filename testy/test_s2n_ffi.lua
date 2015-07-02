--[[
	This 'test' won't actually work, as it's just a fragment
	from the web page.

	What it will show is that the ffi can be included without
	error.
	
--]]

package.path = "../?.lua;"..package.path

local s2n_ffi = require("s2n_ffi")
s2n_ffi();

local conn = s2n_connection_new(S2N_SERVER);
if conn == nil then
	error(s2n_strerror(-1));
end

-- Associate a connection with a file descriptor
if (s2n_connection_set_fd(conn, fd) < 0) then
	error();
end

-- Negotiate TLS handshake
local more = ffi.new("int[1]");
if (s2n_negotiate(conn, more) < 0) then
	error();
end

-- Write data to connection
local bytes_written = s2n_send(conn, "Hello, World", 12, more);
