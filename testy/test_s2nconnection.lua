-- test_s2nconnection.lua
package.path = "../?.lua;"..package.path

local s2n = require("s2n")
local S2NConnection = s2n.S2NConnection;

local function test_negotiate()
	-- negotiate without actually connecting to something
	-- should cause an error.
	local conn = S2NConnection();

	print("conn negotiate: ", conn:negotiate());
end

local function test_getmetainfo()
	local conn = S2NConnection();

	print("server name: ", conn:serverName());
	print("app protocol: ", conn:applicationProtocol())
	print("client Version: ", conn:clientProtocolVersion())
	print("server Version: ", conn:serverProtocolVersion())
	print("actual Version: ", conn:actualProtocolVersion())
end

test_getmetainfo();
