A LuaJIT binding to the s2n TLS library


If you want to use the binding as if you were programming in 
C, then, the only file that is actually needed is: api/s2n_ffi.lua

This will give you the raw API functions of the s2n library.

If you want more of a Lua feel, then you'll want to use the 
s2n.lua file, wich will over time contain various 'class' constructs
which are more convenient to use.

This binding is a work in progress, and only the core API is effective
at the moment.  

The S2NConnection object is fairly complex, but will be more complete
once the Configuration object is finished as well.


