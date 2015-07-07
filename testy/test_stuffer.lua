package.path = "../?.lua;"..package.path
local ffi = require("ffi")

local s2n_api = require("api.s2n_ffi")
local stuffit = require("stuffer.s2n_stuffer")

-- put them in global namespace
for k,v in pairs(stuffit) do
	_G[k] = v;
end

local function EXPECTSUCCESS(f, ...)
	local err = f(...)
	if err < 0 then
		local errstr = s2n_api.s2n_strerror();
		error(errstr)
	end
end

local function test_metadata()
	print("==== test_metadata ====")
	local stuffer = s2n_stuffer();
	s2n_stuffer_growable_alloc(stuffer, 10);

	local avail = s2n_stuffer_data_available(stuffer)
	local remains = s2n_stuffer_space_remaining(stuffer)

	print("Available: ", avail)
	print("Remaining: ", remains)

	print("After Writing Some")
	s2n_stuffer_write_str(stuffer, "the quick brown fox jumped over the lazy dogs back")
	print("Available: ", s2n_stuffer_data_available(stuffer))
	print("Remaining: ", s2n_stuffer_space_remaining(stuffer))
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

local function test_readstring()
	local teststr = "the quick brown fox jumped over the lazy dogs back"
	local stuffer = s2n_stuffer();
	s2n_stuffer_growable_alloc(stuffer, 10);

	local err = s2n_stuffer_write_str(stuffer, teststr)

	print("written: ", err)
	local buff = ffi.new("uint8_t[?]", #teststr+1)
	EXPECTSUCCESS(s2n_stuffer_reread, stuffer);
	EXPECTSUCCESS(s2n_stuffer_read_bytes, stuffer, buff, #teststr);

	if err < 0 then
		local errstr = s2n_api.s2n_strerror();
		print(errstr)
		return false, errstr;
	end

	print(ffi.string(buff,#teststr))
end

--test_growable()
--test_metadata()
test_readstring();
