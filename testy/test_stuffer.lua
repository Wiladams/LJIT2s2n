package.path = "../?.lua;"..package.path
local ffi = require("ffi")

local stuffit = require("stuffer.s2n_stuffer")

-- put them in global namespace
for k,v in pairs(stuffit) do
	_G[k] = v;
end

local function test_growable()
	print("==== test_growable ====")
	local stuffer = s2n_stuffer();
	s2n_stuffer_growable_alloc(stuffer, 10);

	-- write some stuff into it
	local written = s2n_stuffer_write_str(stuffer, "the quick brown fox jumped over the lazy dogs back")


	-- rewind to the beginning
	local buff = ffi.new("uint8_t[256]")
	s2n_stuffer_reread(stuffer);
	s2n_stuffer_read_bytes(stuffer, buff, 255);
	local str = ffi.string(buff, 255);

	print("READ: ", str)
end

test_growable()
