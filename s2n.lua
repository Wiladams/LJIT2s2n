local ffi = require("ffi")
local s2n_api = require("api.s2n_ffi")

local S2NConnection = {}
setmetatable(S2NConnection, {
	__call = function(self, ...)
		return self:new(...);
	end,
})

local S2NConnection_mt = {
	__index = S2NConnection;
}

function S2NConnection.init(self, handle)
	local obj = {
		Handle = handle;
	}
	setmetatable(obj, S2NConnection_mt);

	return obj;
end

function S2NConnection.new(self, mode)
	mode = mode or s2n_api.S2N_SERVER
	local handle = s2n_api.s2n_connection_new(mode)

	if handle == nil then
		return nil
	end

	-- what to call when handle goes out of scope
	ffi.gc(handle, s2n_api.s2n_connection_free);

	return self:init(handle);
end

function S2NConnection.applicationProtocol(self)
	local str = s2n_api.s2n_get_application_protocol(self.Handle);
	if str == nil then
		return false, s2n_api.s2n_strerror();
	end

	return ffi.string(str);
end

function S2NConnection.blinding(self, value)
	blinding = blinding or s2n_api.S2N_BUILT_IN_BLINDING;
	local err = s2n_api.s2n_connection_set_blinding(self.Handle, blinding);
	
	if err < 0 then
		return false, s2n_api.s2n_strerror();
	end

	return true;
end

-- set the configuration for the connection
function S2NConnection.config(self, value)
end

function S2NConnection.delay(self)
	local delay = s2n_api.s2n_connection_get_delay(self.Handle);
	if delay < 0 then
		return false, s2n_api.s2n_strerror();
	end

	return delay;
end

-- negotiate the handshake/connection
function S2NConnection.negotiate(self)
	local more = ffi.new("int[1]");

	repeat
		local err = s2n_api.s2n_negotiate(self.Handle, more);

		if err < 0 then
			return false, s2n_api.s2n_strerror();
		end
	until more[0] == 0;

	return true;
end

-- get or set the server name
function S2NConnection.serverName(self, value)
	if not value then
		-- get server name
		local server_name = s2n_api.s2n_get_server_name(self.Handle);
		if server_name == nil then
			return false, s2n_api.s2n_strerror();
		end

		return ffi.string(server_name);
	end

	-- set server name
	local err = s2n_api.s2n_set_server_name(self.Handle, value);
	if err < 0 then
		return false, s2n_api.s2n_strerror();
	end
end

function S2NConnection.receive(self, buff, size)
	local more = ffi.new("int[1]")
	local received = s2n_api.s2n_recv(self.Handle,  buff, size, more);

	return true;
end

function S2NConnection.send(self, buff, size)
	local more = ffi.new("int[1]")
	local sent = s2n_api.s2n_send(self.Handle, buff, size, more);

	return true;
end

-- shutdown the connection object
function S2NConnection.shutdown(self)
	local more = ffi.new("int[1]")
	
	repeat
		local err = s2n_api.s2n_shutdown(self.Handle, more);

		if err < 0 then
			return false, s2n_api.s2n_strerror();
		end
	until more[0] == 0

	return true;
end

-- Wipe the connection object before reusing it
-- on another connection
function S2NConnection.wipe(self)
	local err = s2n_api.s2n_connection_wipe(self.Handle);
	if err < 0 then
		return false, s2n_api.s2n_strerror();
	end

	return true;
end

-- Set the file descriptor for both reading and writing
function S2NConnection.fileDescriptor(self, fd)
	local err = s2n_api.s2n_connection_set_fd(self.Handle, fd);

	if err < 0 then
		return false, s2n_api.s2n_strerror();
	end

	return true;
end

-- Set the file descriptor that will be written to
function S2NConnection.writingDescriptor(self, fd)
	local err = s2n_api.s2n_connection_set_write_fd(self.Handle, fd);

	if err < 0 then
		return false, s2n_api.s2n_strerror();
	end

	return true;
end

-- Set the file descriptor that will be read from
function S2NConnection.readingDescriptor(self, fd)
	local err = s2n_api.s2n_connection_set_read_fd(self.Handle, fd);

	if err < 0 then
		return false, s2n_api.s2n_strerror();
	end

	return true;
end

-- total number of bytes on the wire coming in
function S2NConnection.wireBytesIn(self)
	return tonumber(s2n_api.s2n_connection_get_wire_bytes_in(self.Handle));
end

-- total number of bytes on the wire going out
function S2NConnection.wireBytesOut(self)	
	return tonumber(s2n_api.s2n_connection_get_wire_bytes_out(self.Handle));
end

--[[
extern const uint8_t *s2n_connection_get_ocsp_response(struct s2n_connection *conn, uint32_t *length);

extern int s2n_connection_get_client_protocol_version(struct s2n_connection *conn);
extern int s2n_connection_get_server_protocol_version(struct s2n_connection *conn);
extern int s2n_connection_get_actual_protocol_version(struct s2n_connection *conn);
extern int s2n_connection_get_client_hello_version(struct s2n_connection *conn);
extern const char *s2n_connection_get_cipher(struct s2n_connection *conn);
extern int s2n_connection_get_alert(struct s2n_connection *conn);
--]]

local exports = {
	S2NConnection = S2NConnection;
}

return exports
