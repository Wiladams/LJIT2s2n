local ffi = require("ffi")
local s2n_api = require("api.s2n_ffi")
local S2NConnection = require("S2NConnection");

local exports = {
	s2n_api = s2n_api;

	-- classes
	S2NConnection = S2NConnection;
}


return exports
