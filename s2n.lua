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

function S2NConnection.config(self, value)
end

function S2NConnection.delay(self)
	local delay = s2n_api.s2n_connection_get_delay(self.Handle);
	if delay < 0 then
		return false, s2n_api.s2n_strerror();
	end

	return delay;
end

function S2NConnection.negotiate(self)
	local more = ffi.new("int[1]");
	local err = s2n_api.s2n_negotiate(self.Handle, more);

	if err < 0 then
		return false, s2n_api.s2n_strerror();
	end

	return more[0] ~= 0;
end

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


function S2NConnection.shutdown(self)
	local more = ffi.new("int[1]")
	local err = s2n_api.s2n_shutdown(self.Handle, more);

	if err < 0 then
		return false, s2n_api.s2n_strerror();
	end

	return more[0] ~= 0;
end

function S2NConnection.wipe(self)
	local err = s2n_api.s2n_connection_wipe(self.Handle);
	if err < 0 then
		return false, s2n_api.s2n_strerror();
	end

	return true;
end



local exports = {
	S2NConnection = S2NConnection;
}

return exports