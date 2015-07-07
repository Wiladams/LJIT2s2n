local ffi = require("ffi")
local s2n_api = require("api.s2n_ffi")

local S2NConfig = {}
setmetatable(S2Config, {
	__call = function(self, ...)
		return self:new(...);
	end,
})
local S2Config_mt = {
	__index = S2Config
}

function S2NConfig.init(self, ...)
	local obj = {

	}
	setmetatable(obj, S2Config_mt);

	return obj;
end

function S2NConfig.new(self, ...)
	local handle = s2n_api.s2n_config_new();
	if handle == nil then
		return nil
	end

	-- What to call if the handle goes out of scope
	ffi.gc(handle, s2n_api.s2n_config_free);

	return self:init(handle);
end

-- char * cert_chain_pem
-- char * private_key_pem
function S2Config.addCertChainAndKey(self, cert_chain_pem, private_key_pem)
	self.cert_chain_pem = cert_chain_pem;
	self.private_key_pem = private_key_pem;
	
	local err = s2n_api.s2n_config_add_cert_chain_and_key(self.Handle, 
		cert_chain_pem, private_key_pem);

	if err < 0 then
		return false, s2n_api.s2n_strerror();
	end

	return true;
end

function S2Config.addDhParams(self, dhparams_pem)
	local err = s2n_api.s2n_config_add_dhparams(self.Handle, dhparams_pem)

	if err < 0 then
		return false, s2n_api.s2n_strerror();
	end

	return true;
end

--[[
extern int s2n_config_free_dhparams(struct s2n_config *config);
extern int s2n_config_free_cert_chain_and_key(struct s2n_config *config);
extern int s2n_config_add_cert_chain_and_key_with_status(struct s2n_config *config,
        char *cert_chain_pem, char *private_key_pem, const uint8_t *status, uint32_t length);

extern int s2n_config_set_key_exchange_preferences(struct s2n_config *config, const char *preferences);
extern int s2n_config_set_cipher_preferences(struct s2n_config *config, const char *version);
extern int s2n_config_set_protocol_preferences(struct s2n_config *config, const char * const *protocols, int protocol_count);

extern int s2n_config_set_status_request_type(struct s2n_config *config, s2n_status_request_type type);
--]]

return S2NConfig;
