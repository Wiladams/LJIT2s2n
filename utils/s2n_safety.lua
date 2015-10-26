require("error.s2n_errno")

-- NULL check a pointer */
local function notnull_check( ptr )           
	if ( ptr == nil ) then 
		S2N_ERROR(S2N_ERR_NULL);
	end 
end

-- Check memcpy's return, if it's not right (very unlikely!) bail, set an error
-- err and return -1;
--
local function memcpy_check( d, s, n )     
	notnull_check( (d) ); 
	if ( memcpy( (d), (s), (n)) != (d) ) then
		S2N_ERROR(S2N_ERR_MEMCPY)
	end
end

local function memset_check( d, c, n )     
	notnull_check( (d) ); if ( memset( (d), (c), (n)) != (d) ) { S2N_ERROR(S2N_ERR_MEMSET); } } while(0)
end

-- Range check a number
local function gte_check(n, min)
	if ( (n) < min ) then
		S2N_ERROR(S2N_ERR_SAFETY); 
	end 
end

local function lte_check(n, max)   
	if ( (n) > max ) then
		S2N_ERROR(S2N_ERR_SAFETY); 
	end
end

local function gt_check(n, min)   if ( (n) <= min ) { S2N_ERROR(S2N_ERR_SAFETY); } } end
local function lt_check(n, max)   if ( (n) >= max ) { S2N_ERROR(S2N_ERR_SAFETY); } } end
local function eq_check(a, b)   if ( (a) != (b) ) { S2N_ERROR(S2N_ERR_SAFETY); } } end
local function ne_check(a, b)   if ( (a) == (b) ) { S2N_ERROR(S2N_ERR_SAFETY); } } end
local function inclusive_range_check( low, n, high )  gte_check(n, low); lte_check(n, high)
local function exclusive_range_check( low, n, high )  gt_check(n, low); lt_check(n, high)

local function GUARD( x )      
	if (x < 0 ) return -1
end


local function GUARD_PTR( x )  
	if ( x < 0 ) return nil
end

local exports = {
	-- local functions
	GUARD = GUARD;
	GUARD_PTR = GUARD_PTR;
}

setmetatable(exports, {
	__call = function(self)
		for k,v in pairs(exports) do
			_G[k] = v;
		end
	end,
	})

return exports
