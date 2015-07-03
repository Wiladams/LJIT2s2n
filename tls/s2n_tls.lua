require("tls.s2n_connection")

ffi.cdef[[
extern uint8_t s2n_highest_protocol_version;

/* 
 * A TLS session ID is between 0 and 32 bytes
 */
struct s2n_tls_session_id {
    uint8_t session_id[32];
    uint8_t session_id_len;
};

extern int s2n_flush(struct s2n_connection *conn, int *more);
extern int s2n_client_hello_send(struct s2n_connection *conn);
extern int s2n_client_hello_recv(struct s2n_connection *conn);
extern int s2n_sslv2_client_hello_recv(struct s2n_connection *conn);
extern int s2n_server_hello_send(struct s2n_connection *conn);
extern int s2n_server_hello_recv(struct s2n_connection *conn);
extern int s2n_server_cert_send(struct s2n_connection *conn);
extern int s2n_server_cert_recv(struct s2n_connection *conn);
extern int s2n_server_status_send(struct s2n_connection *conn);
extern int s2n_server_status_recv(struct s2n_connection *conn);
extern int s2n_server_key_send(struct s2n_connection *conn);
extern int s2n_server_key_recv(struct s2n_connection *conn);
extern int s2n_server_done_send(struct s2n_connection *conn);
extern int s2n_server_done_recv(struct s2n_connection *conn);
extern int s2n_client_key_send(struct s2n_connection *conn);
extern int s2n_client_key_recv(struct s2n_connection *conn);
extern int s2n_client_ccs_send(struct s2n_connection *conn);
extern int s2n_client_ccs_recv(struct s2n_connection *conn);
extern int s2n_server_ccs_send(struct s2n_connection *conn);
extern int s2n_server_ccs_recv(struct s2n_connection *conn);
extern int s2n_client_finished_send(struct s2n_connection *conn);
extern int s2n_client_finished_recv(struct s2n_connection *conn);
extern int s2n_server_finished_send(struct s2n_connection *conn);
extern int s2n_server_finished_recv(struct s2n_connection *conn);
extern int s2n_handshake_write_header(struct s2n_connection *conn, uint8_t message_type);
extern int s2n_handshake_finish_header(struct s2n_connection *conn);
extern int s2n_handshake_parse_header(struct s2n_connection *conn, uint8_t *message_type, uint32_t *length);
extern int s2n_read_full_record(struct s2n_connection *conn, uint8_t *record_type, int *isSSLv2);
extern int s2n_client_extensions_send(struct s2n_connection *conn, struct s2n_stuffer *out);
extern int s2n_client_extensions_recv(struct s2n_connection *conn, struct s2n_blob *extensions);
extern int s2n_server_extensions_send(struct s2n_connection *conn, struct s2n_stuffer *out);
extern int s2n_server_extensions_recv(struct s2n_connection *conn, struct s2n_blob *extensions);
]]


local function s2n_server_can_send_ocsp(conn) 
	return ((conn)->status_type == S2N_STATUS_REQUEST_OCSP && \
        (conn)->config->cert_and_key_pairs && \
        (conn)->config->cert_and_key_pairs->ocsp_status.size > 0)
end 

local exports = {}

return exports
