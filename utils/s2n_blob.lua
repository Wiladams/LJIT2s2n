local ffi = require("ffi")

ffi.cdef[[
struct s2n_blob {
    uint8_t *data;
    uint32_t size;
};

extern int s2n_blob_init(struct s2n_blob *b, uint8_t *data, uint32_t size);
extern int s2n_blob_zero(struct s2n_blob *b);
]]

local exports = {
	
}

return exports
