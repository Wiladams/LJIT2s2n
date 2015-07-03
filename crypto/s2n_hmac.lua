
local ffi = require("ffi")

require("crypto.s2n_hash")

ffi.cdef[[
typedef enum { 
    S2N_HMAC_NONE, 
    S2N_HMAC_MD5, 
    S2N_HMAC_SHA1, 
    S2N_HMAC_SHA224, 
    S2N_HMAC_SHA256, 
    S2N_HMAC_SHA384,
    S2N_HMAC_SHA512, 
    S2N_HMAC_SSLv3_MD5, 
    S2N_HMAC_SSLv3_SHA1
} s2n_hmac_algorithm;

struct s2n_hmac_state {
    s2n_hmac_algorithm alg;

    uint16_t block_size;
    uint8_t digest_size;

    struct s2n_hash_state inner;
    struct s2n_hash_state inner_just_key;
    struct s2n_hash_state outer;

    /* key needs to be as large as the biggest block size */
    uint8_t xor_pad[128];

    /* For storing the inner digest */
    uint8_t digest_pad[SHA512_DIGEST_LENGTH];
};
]]

ffi.cdef[[
extern int s2n_hmac_digest_size(s2n_hmac_algorithm alg);

extern int s2n_hmac_init(struct s2n_hmac_state *state, s2n_hmac_algorithm alg, const void *key, uint32_t klen);
extern int s2n_hmac_update(struct s2n_hmac_state *state, const void *in, uint32_t size);
extern int s2n_hmac_digest(struct s2n_hmac_state *state, void *out, uint32_t size);
extern int s2n_hmac_digest_verify(const void *a, uint32_t alen, const void *b, uint32_t blen);
extern int s2n_hmac_reset(struct s2n_hmac_state *state);
extern int s2n_hmac_copy(struct s2n_hmac_state *to, struct s2n_hmac_state *from);
]]

local exports = {}

return exports
