local ffi = require("ffi")


local connection = require("tls.s2n_connection")

ffi.cdef[[
extern int s2n_process_alert_fragment(struct s2n_connection *conn);
extern int s2n_queue_writer_close_alert(struct s2n_connection *conn);
extern int s2n_queue_reader_close_alert(struct s2n_connection *conn);
extern int s2n_queue_reader_unsupported_protocol_version_alert(struct s2n_connection *conn);
]]

local exports = {

}

return exports