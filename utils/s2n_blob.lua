local ffi = require("ffi")

local Lib_s2n = ffi.load("s2n", true)

ffi.cdef[[
struct s2n_blob {
    uint8_t *data;
    uint32_t size;
};

extern int s2n_blob_init(struct s2n_blob *b, uint8_t *data, uint32_t size);
extern int s2n_blob_zero(struct s2n_blob *b);
]]

local s2n_blob = ffi.typeof("struct s2n_blob")
local s2n_blob_mt = {
	__new = function(ct, data, size)
		size = size or 0
--[[
-- if we're passed a string, we should make a copy of it
-- and free it when out of scope.  But, that's fairly impossible
-- as we don't know when the blob object will go out of scope.
		if type(data) == "string" then
			data = strdup(data);
			ffi.gc(data, ffi.C.free)
		end
--]]
		return ffi.new(ct, data, size);
	end,

	__index = {
		clear = function(self)
			ffi.fill(self, ffi.sizeof(self), 0);
		end,
	},

	__tostring = function(self)
		return string.format("0x%x [%d]", tonumber(ffi.cast("intptr_t",self.data)), tonumber(self.size));
	end,
}
ffi.metatype(s2n_blob, s2n_blob_mt);


local exports = {
	s2n_blob = s2n_blob;

	-- library functions
	s2n_blob_init = Lib_s2n.s2n_blob_init;
	s2n_blob_zero = Lib_s2n.s2n_blob_zero;
}

return exports
