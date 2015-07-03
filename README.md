A LuaJIT binding to the s2n TLS library


The only file that is actually needed is: api/s2n_ffi.lua

This contains what is considered to be the "API" of this library.

All other files are core components, and should not be referred to 
directly from within your programs.  They are built up here to see
how much of them can be improved via Lua implementation, for example, 
turning error codes into string values could be a simple lua table
lookup.

The testy/ directory will contain some sample code of how to use
various parts of the library.