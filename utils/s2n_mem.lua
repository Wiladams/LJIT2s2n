local ffi = require("ffi")

require("utils.s2n_blob")

local Lib_s2n = ffi.load("s2n", true)

ffi.cdef[[
int s2n_alloc(struct s2n_blob *b, uint32_t size);
int s2n_realloc(struct s2n_blob *b, uint32_t size);
int s2n_free(struct s2n_blob *b);
]]


local exports = {
	s2n_alloc = Lib_s2n.s2n_alloc;
	s2n_realloc = Lib_s2n.s2n_realloc;
	s2n_free = Lib_s2n.s2n_free;
}

return exports
