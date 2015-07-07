package.path = "../?.lua;"..package.path
local ffi = require("ffi")

local s2n_blob = require("utils.s2n_blob").s2n_blob

local function test_constructor()
	print("==== test_constructor ====")
	local blob1 = s2n_blob();
	print("Blob1: ", tostring(blob1))

	local str = "Hello, World!"
	local blob2 = s2n_blob(ffi.cast("uint8_t *",str), #str)
	print("Blob2: ", tostring(blob2))
end

local function test_clear()
	print("==== test_clear ====")
	local str = "Hello, World!"
	local blob1 = s2n_blob(ffi.cast("uint8_t *",str), #str)
	print("Blob1: ", tostring(blob1))

	blob1:clear();
	print("Blob Clear: ", blob1)
end

test_constructor();
test_clear();