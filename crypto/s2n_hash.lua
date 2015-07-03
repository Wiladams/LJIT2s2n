
local ffi = require("ffi")

if __APPLE__ and __MACH__ then
--[[
#define COMMON_DIGEST_FOR_OPENSSL
#include <CommonCrypto/CommonDigest.h>
#define SHA1 CC_SHA1
#define SHA224 CC_SHA224
#define SHA256 CC_SHA256
#define SHA384 CC_SHA384
#define SHA512 CC_SHA512

#include <CommonCrypto/CommonHMAC.h>
#define HMAC CCHmac
--]]
else
--require("openssl.md5")
--require("openssl.sha")
end

ffi.cdef[[
typedef enum { 
    S2N_HASH_NONE, 
    S2N_HASH_MD5, 
    S2N_HASH_SHA1, 
    S2N_HASH_SHA224, 
    S2N_HASH_SHA256, 
    S2N_HASH_SHA384,
    S2N_HASH_SHA512, 
    S2N_HASH_MD5_SHA1
} s2n_hash_algorithm;

struct s2n_hash_state {
    s2n_hash_algorithm alg;
    union {
        MD5_CTX md5;
        SHA_CTX sha1;
        SHA256_CTX sha224;
        SHA256_CTX sha256;
        SHA512_CTX sha384;
        SHA512_CTX sha512;
        struct {
            MD5_CTX md5;
            SHA_CTX sha1;
        } md5_sha1;
    } hash_ctx;
};

extern int s2n_hash_digest_size(s2n_hash_algorithm alg);

extern int s2n_hash_init(struct s2n_hash_state *state, s2n_hash_algorithm alg);
extern int s2n_hash_update(struct s2n_hash_state *state, const void *in, uint32_t size);
extern int s2n_hash_digest(struct s2n_hash_state *state, void *out, uint32_t size);
extern int s2n_hash_reset(struct s2n_hash_state *state);
extern int s2n_hash_copy(struct s2n_hash_state *to, struct s2n_hash_state *from); 
]]

local exports = {}

return exports
