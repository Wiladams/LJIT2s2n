
require ("tls.s2n_connection")

ffi.cdef[[
extern int s2n_record_max_write_payload_size(struct s2n_connection *conn);
extern int s2n_record_write(struct s2n_connection *conn, uint8_t content_type, struct s2n_blob *in);
extern int s2n_record_parse(struct s2n_connection *conn);
extern int s2n_record_header_parse(struct s2n_connection *conn, uint8_t *content_type, uint16_t *fragment_length);
extern int s2n_sslv2_record_header_parse(struct s2n_connection *conn, uint8_t *record_type, uint8_t *client_protocol_version, uint16_t *fragment_length);
extern int s2n_cbc_masks_init();
extern int s2n_verify_cbc(struct s2n_connection *conn, struct s2n_hmac_state *hmac, struct s2n_blob *decrypted);
extern int s2n_aead_aad_init(const struct s2n_connection *conn, uint8_t *sequence_number, uint8_t content_type, uint16_t record_length, struct s2n_stuffer *ad);
]]

local exports = {}

return exports