local ffi = require("ffi")

require("utils.s2n_blob")


ffi.cdef[[
int s2n_alloc(struct s2n_blob *b, uint32_t size);
int s2n_realloc(struct s2n_blob *b, uint32_t size);
int s2n_free(struct s2n_blob *b);
]]
