local ffi = require("ffi")

local Lib_ssl = ffi.load("ssl", true)
local Lib_s2n = ffi.load("s2n", true)

local S2N_SSLv2 = 20;
local S2N_SSLv3 = 30;
local S2N_TLS10 = 31;
local S2N_TLS11 = 32;
local S2N_TLS12 = 33;

--extern __thread int s2n_errno;

ffi.cdef[[
typedef intptr_t ssize_t;

struct s2n_config;

extern int s2n_init();
extern int s2n_cleanup();
extern struct s2n_config *s2n_config_new();
extern int s2n_config_free(struct s2n_config *config);
extern int s2n_config_free_dhparams(struct s2n_config *config);
extern int s2n_config_free_cert_chain_and_key(struct s2n_config *config);
extern const char *s2n_strerror(int error, const char *lang);

extern int s2n_config_add_cert_chain_and_key(struct s2n_config *config, char *cert_chain_pem, char *private_key_pem);
extern int s2n_config_add_cert_chain_and_key_with_status(struct s2n_config *config,
        char *cert_chain_pem, char *private_key_pem, const uint8_t *status, uint32_t length);
extern int s2n_config_add_dhparams(struct s2n_config *config, char *dhparams_pem);
extern int s2n_config_set_key_exchange_preferences(struct s2n_config *config, const char *preferences);
extern int s2n_config_set_cipher_preferences(struct s2n_config *config, const char *version);
extern int s2n_config_set_protocol_preferences(struct s2n_config *config, const char * const *protocols, int protocol_count);

typedef enum { 
	S2N_STATUS_REQUEST_NONE = 0, 
	S2N_STATUS_REQUEST_OCSP = 1 
} s2n_status_request_type;

extern int s2n_config_set_status_request_type(struct s2n_config *config, s2n_status_request_type type);

struct s2n_connection;

typedef enum { 
	S2N_SERVER, 
	S2N_CLIENT 
} s2n_mode;

extern struct s2n_connection *s2n_connection_new(s2n_mode mode);
extern int s2n_connection_set_config(struct s2n_connection *conn, struct s2n_config *config);

extern int s2n_connection_set_fd(struct s2n_connection *conn, int readfd);
extern int s2n_connection_set_read_fd(struct s2n_connection *conn, int readfd);
extern int s2n_connection_set_write_fd(struct s2n_connection *conn, int readfd);

typedef enum { 
	S2N_BUILT_IN_BLINDING, 
	S2N_SELF_SERVICE_BLINDING 
} s2n_blinding;

extern int s2n_connection_set_blinding(struct s2n_connection *conn, s2n_blinding blinding);
extern int s2n_connection_get_delay(struct s2n_connection *conn);

extern int s2n_set_server_name(struct s2n_connection *conn, const char *server_name);
extern const char *s2n_get_server_name(struct s2n_connection *conn);
extern const char *s2n_get_application_protocol(struct s2n_connection *conn);
extern const uint8_t *s2n_connection_get_ocsp_response(struct s2n_connection *conn, uint32_t *length);

extern int s2n_negotiate(struct s2n_connection *conn, int *more);
extern ssize_t s2n_send(struct s2n_connection *conn, void *buf, ssize_t size, int *more);
extern ssize_t s2n_recv(struct s2n_connection *conn,  void *buf, ssize_t size, int *more);
extern int s2n_shutdown(struct s2n_connection *conn, int *more);

extern int s2n_connection_wipe(struct s2n_connection *conn);
extern int s2n_connection_free(struct s2n_connection *conn);
//extern int s2n_shutdown(struct s2n_connection *conn, int *more);

extern uint64_t s2n_connection_get_wire_bytes_in(struct s2n_connection *conn);
extern uint64_t s2n_connection_get_wire_bytes_out(struct s2n_connection *conn);
extern int s2n_connection_get_client_protocol_version(struct s2n_connection *conn);
extern int s2n_connection_get_server_protocol_version(struct s2n_connection *conn);
extern int s2n_connection_get_actual_protocol_version(struct s2n_connection *conn);
extern int s2n_connection_get_client_hello_version(struct s2n_connection *conn);
extern const char *s2n_connection_get_cipher(struct s2n_connection *conn);
extern int s2n_connection_get_alert(struct s2n_connection *conn);
]]

local function strerror(errcode)
	local errstr = Lib_s2n.s2n_strerror(errcode, "EN");
	if errstr == nil then
		return "UNKNOWN ERROR";
	end

	return ffi.string(errstr);
end

local exports = {
	Lib_s2n = Lib_s2n;

	-- some constants
	S2N_SSLv2 = S2N_SSLv2;
	S2N_SSLv3 = S2N_SSLv3;
	S2N_TLS10 = S2N_TLS10;
	S2N_TLS11 = S2N_TLS11;
	S2N_TLS12 = S2N_TLS12;
	
	-- enums
	-- s2n_mode
	S2N_SERVER = ffi.C.S2N_SERVER;
	S2N_CLIENT = ffi.C.S2N_CLIENT;

	-- library functions
	s2n_init = Lib_s2n.s2n_init;
	s2n_cleanup = Lib_s2n.s2n_cleanup;
	s2n_strerror = strerror;

	s2n_set_server_name = Lib_s2n.s2n_set_server_name;
	s2n_get_server_name = Lib_s2n.s2n_get_server_name;
	s2n_get_application_protocol = Lib_s2n.s2n_get_application_protocol;
	s2n_connection_get_ocsp_response = Lib_s2n.s2n_connection_get_ocsp_response;

	s2n_negotiate = Lib_s2n.s2n_negotiate;
	s2n_send = Lib_s2n.s2n_send;
	s2n_recv = Lib_s2n.s2n_recv;
	s2n_shutdown = Lib_s2n.s2n_shutdown;


	s2n_config_new = Lib_s2n.s2n_config_new;
	s2n_config_free = Lib_s2n.s2n_config_free;
	s2n_config_free_dhparams = Lib_s2n.s2n_config_free_dhparams;
	s2n_config_free_cert_chain_and_key = Lib_s2n.s2n_config_free_cert_chain_and_key;
	s2n_config_add_cert_chain_and_key = Lib_s2n.s2n_config_add_cert_chain_and_key;
	s2n_config_add_cert_chain_and_key_with_status = Lib_s2n.s2n_config_add_cert_chain_and_key_with_status;
	s2n_config_add_dhparams = Lib_s2n.s2n_config_add_dhparams;
	--s2n_config_set_key_exchange_preferences = Lib_s2n.s2n_config_set_key_exchange_preferences;
	s2n_config_set_cipher_preferences = Lib_s2n.s2n_config_set_cipher_preferences;
	s2n_config_set_protocol_preferences = Lib_s2n.s2n_config_set_protocol_preferences;
	s2n_config_set_status_request_type = Lib_s2n.s2n_config_set_status_request_type;

	s2n_connection_new = Lib_s2n.s2n_connection_new;
	s2n_connection_set_config = Lib_s2n.s2n_connection_set_config;
	s2n_connection_set_fd = Lib_s2n.s2n_connection_set_fd;
	s2n_connection_set_read_fd = Lib_s2n.s2n_connection_set_read_fd;
	s2n_connection_set_write_fd = Lib_s2n.s2n_connection_set_write_fd;
	s2n_connection_set_blinding = Lib_s2n.s2n_connection_set_blinding;
	s2n_connection_get_delay = Lib_s2n.s2n_connection_get_delay;
	s2n_connection_wipe = Lib_s2n.s2n_connection_wipe;
	s2n_connection_free = Lib_s2n.s2n_connection_free;
	s2n_connection_get_wire_bytes_in = Lib_s2n.s2n_connection_get_wire_bytes_in;
	s2n_connection_get_wire_bytes_out = Lib_s2n.s2n_connection_get_wire_bytes_out;
	s2n_connection_get_client_protocol_version = Lib_s2n.s2n_connection_get_client_protocol_version;
	s2n_connection_get_server_protocol_version = Lib_s2n.s2n_connection_get_server_protocol_version;
	s2n_connection_get_actual_protocol_version = Lib_s2n.s2n_connection_get_actual_protocol_version;
	s2n_connection_get_client_hello_version = Lib_s2n.s2n_connection_get_client_hello_version;
	s2n_connection_get_cipher = Lib_s2n.s2n_connection_get_cipher;
	s2n_connection_get_alert = Lib_s2n.s2n_connection_get_alert;
}


Lib_s2n.s2n_init();

setmetatable(exports, {
	__call = function(self, ...)
		for k,v in pairs(exports) do
			_G[k] = v;
		end
	end,
})

return exports;
