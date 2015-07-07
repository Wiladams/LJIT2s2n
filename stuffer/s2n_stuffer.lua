local ffi = require("ffi")

local s2n_blob = require ("utils.s2n_blob")

ffi.cdef[[
struct s2n_stuffer {
    /* The data for the s2n_stuffer */
    struct s2n_blob blob;

    /* Cursors to the current read/write position in the s2n_stuffer */
    uint32_t read_cursor;
    uint32_t write_cursor;

    /* The total size of the data segment */
    /* Has the stuffer been wiped? */
    unsigned int wiped:1;

    /* Was this stuffer alloc()'d ? */
    unsigned int alloced:1;

    /* Is this stuffer growable? */
    unsigned int growable:1;

    /* A growable stuffer can also be temporarily tainted */
    unsigned int tainted:1;
};
]]

local function s2n_stuffer_data_available( s )   
    return (s.write_cursor - s.read_cursor)
end 

local function s2n_stuffer_space_remaining( s )  
    return (s.blob.size - s.write_cursor)
end

ffi.cdef[[
/* Initialize and destroying stuffers */
extern int s2n_stuffer_init(struct s2n_stuffer *stuffer, struct s2n_blob *in);
extern int s2n_stuffer_alloc(struct s2n_stuffer *stuffer, uint32_t size);
extern int s2n_stuffer_growable_alloc(struct s2n_stuffer *stuffer, uint32_t size);
extern int s2n_stuffer_free(struct s2n_stuffer *stuffer);
extern int s2n_stuffer_resize(struct s2n_stuffer *stuffer, uint32_t size);
extern int s2n_stuffer_reread(struct s2n_stuffer *stuffer);
extern int s2n_stuffer_rewrite(struct s2n_stuffer *stuffer);
extern int s2n_stuffer_wipe(struct s2n_stuffer *stuffer);
extern int s2n_stuffer_wipe_n(struct s2n_stuffer *stuffer, uint32_t n);

/* Basic read and write */
extern int s2n_stuffer_read(struct s2n_stuffer *stuffer, struct s2n_blob *out);
extern int s2n_stuffer_erase_and_read(struct s2n_stuffer *stuffer, struct s2n_blob *out);
extern int s2n_stuffer_write(struct s2n_stuffer *stuffer, struct s2n_blob *in);
extern int s2n_stuffer_read_bytes(struct s2n_stuffer *stuffer, uint8_t *out, uint32_t n);
extern int s2n_stuffer_write_bytes(struct s2n_stuffer *stuffer, uint8_t *in, uint32_t n);
extern int s2n_stuffer_skip_read(struct s2n_stuffer *stuffer, uint32_t n);
extern int s2n_stuffer_skip_write(struct s2n_stuffer *stuffer, uint32_t n);

/* Raw read/write move the cursor along and give you a pointer you can
 * read/write data_len bytes from/to in-place.
 */
extern void *s2n_stuffer_raw_write(struct s2n_stuffer *stuffer, uint32_t data_len);
extern void *s2n_stuffer_raw_read(struct s2n_stuffer *stuffer, uint32_t data_len);

/* Send/receive stuffer to/from a file descriptor */
extern int s2n_stuffer_recv_from_fd(struct s2n_stuffer *stuffer, int rfd, uint32_t len);
extern int s2n_stuffer_send_to_fd(struct s2n_stuffer *stuffer, int wfd, uint32_t len);

/* Read and write integers in network order */
extern int s2n_stuffer_read_uint8(struct s2n_stuffer *stuffer, uint8_t *u);
extern int s2n_stuffer_read_uint16(struct s2n_stuffer *stuffer, uint16_t *u);
extern int s2n_stuffer_read_uint24(struct s2n_stuffer *stuffer, uint32_t *u);
extern int s2n_stuffer_read_uint32(struct s2n_stuffer *stuffer, uint32_t *u);
extern int s2n_stuffer_read_uint64(struct s2n_stuffer *stuffer, uint64_t *u);

extern int s2n_stuffer_write_uint8(struct s2n_stuffer *stuffer, uint8_t u);
extern int s2n_stuffer_write_uint16(struct s2n_stuffer *stuffer, uint16_t u);
extern int s2n_stuffer_write_uint24(struct s2n_stuffer *stuffer, uint32_t u);
extern int s2n_stuffer_write_uint32(struct s2n_stuffer *stuffer, uint32_t u);
extern int s2n_stuffer_write_uint64(struct s2n_stuffer *stuffer, uint64_t u);

/* Copy one stuffer to another */
extern int s2n_stuffer_copy(struct s2n_stuffer *from, struct s2n_stuffer *to, uint32_t len);

/* Read and write base64 */
extern int s2n_stuffer_read_base64(struct s2n_stuffer *stuffer, struct s2n_stuffer *out);
extern int s2n_stuffer_write_base64(struct s2n_stuffer *stuffer, struct s2n_stuffer *in);
]]



ffi.cdef[[
extern int s2n_stuffer_peek_char(struct s2n_stuffer *stuffer, char *c);
extern int s2n_stuffer_read_token(struct s2n_stuffer *stuffer, struct s2n_stuffer *token, char delim);
extern int s2n_stuffer_skip_whitespace(struct s2n_stuffer *stuffer);
extern int s2n_stuffer_alloc_ro_from_string(struct s2n_stuffer *stuffer, char *str);

/* Read an RSA private key from a PEM encoded stuffer to an ASN1/DER encoded one */
extern int s2n_stuffer_rsa_private_key_from_pem(struct s2n_stuffer *pem, struct s2n_stuffer *asn1);

/* Read a certificate  from a PEM encoded stuffer to an ASN1/DER encoded one */
extern int s2n_stuffer_certificate_from_pem(struct s2n_stuffer *pem, struct s2n_stuffer *asn1);

/* Read DH parameters om a PEM encoded stuffer to a PKCS3 encoded one */
extern int s2n_stuffer_dhparams_from_pem(struct s2n_stuffer *pem, struct s2n_stuffer *pkcs3);
]]


-- Useful for text manipulation ... 
local Lib_s2n = ffi.load("s2n")

local function s2n_stuffer_init_text( stuffer, text, len)  
    return Lib_s2n.s2n_stuffer_init(stuffer, ffi.cast("uint8_t *", text), len)
end

local function s2n_stuffer_write_char( stuffer, c)  
    return Lib_s2n.s2n_stuffer_write_uint8(stuffer, ffi.cast("uint8_t", c))
end

local function s2n_stuffer_read_char( stuffer, c)  
    return Lib_s2n.s2n_stuffer_read_uint8(stuffer, ffi.cast("uint8_t *", c))
end

local function s2n_stuffer_write_str( stuffer, c)  
    local blob = s2n_blob.s2n_blob(ffi.cast("uint8_t *",c), #c)
    return Lib_s2n.s2n_stuffer_write(stuffer, blob)
end

local function s2n_stuffer_write_text( stuffer, c, n)  
    return Lib_s2n.s2n_stuffer_write(stuffer, ffi.cast("const uint8_t *", c), n)
end

local function s2n_stuffer_read_text( stuffer, c, n)  
    return Lib_s2n.s2n_stuffer_read(stuffer, ffi.cast("uint8_t *", c), n)
end

local exports = {
    s2n_stuffer = ffi.typeof("struct s2n_stuffer");

    -- local functions
    s2n_stuffer_data_available = s2n_stuffer_data_available;
    s2n_stuffer_space_remaining = s2n_stuffer_space_remaining;

    s2n_stuffer_init_text = s2n_stuffer_init_text;
    s2n_stuffer_write_char = s2n_stuffer_write_char;
    s2n_stuffer_read_char = s2n_stuffer_read_char;
    s2n_stuffer_write_str = s2n_stuffer_write_str;
    s2n_stuffer_write_text = s2n_stuffer_write_text;
    s2n_stuffer_read_text = s2n_stuffer_read_text;

    -- library functions
    s2n_stuffer_init = Lib_s2n.s2n_stuffer_init;
    s2n_stuffer_alloc = Lib_s2n.s2n_stuffer_alloc;
    s2n_stuffer_growable_alloc = Lib_s2n.s2n_stuffer_growable_alloc;
    s2n_stuffer_free = Lib_s2n.s2n_stuffer_free;
    s2n_stuffer_resize = Lib_s2n.s2n_stuffer_resize;
    s2n_stuffer_reread = Lib_s2n.s2n_stuffer_reread;
    s2n_stuffer_rewrite = Lib_s2n.s2n_stuffer_rewrite;
    s2n_stuffer_wipe = Lib_s2n.s2n_stuffer_wipe;
    s2n_stuffer_wipe_n = Lib_s2n.s2n_stuffer_wipe_n;

    -- basic read/write
    s2n_stuffer_read = Lib_s2n.s2n_stuffer_read;
    s2n_stuffer_erase_and_read = Lib_s2n.s2n_stuffer_erase_and_read;
    s2n_stuffer_write = Lib_s2n.s2n_stuffer_write;
    s2n_stuffer_read_bytes = Lib_s2n.s2n_stuffer_read_bytes;
    s2n_stuffer_write_bytes = Lib_s2n.s2n_stuffer_write_bytes;
    s2n_stuffer_skip_read = Lib_s2n.s2n_stuffer_skip_read;
    s2n_stuffer_skip_write = Lib_s2n.s2n_stuffer_skip_write;

    s2n_stuffer_raw_write = Lib_s2n.s2n_stuffer_raw_write;
    s2n_stuffer_raw_read = Lib_s2n.s2n_stuffer_raw_read;

    s2n_stuffer_recv_from_fd = Lib_s2n.s2n_stuffer_recv_from_fd;
    s2n_stuffer_send_to_fd = Lib_s2n.s2n_stuffer_send_to_fd;

    -- read/write integers in network byte order
    s2n_stuffer_read_uint8 = Lib_s2n.s2n_stuffer_read_uint8;
    s2n_stuffer_read_uint16 = Lib_s2n.s2n_stuffer_read_uint16;
    s2n_stuffer_read_uint24 = Lib_s2n.s2n_stuffer_read_uint24;
    s2n_stuffer_read_uint32 = Lib_s2n.s2n_stuffer_read_uint32;
    --s2n_stuffer_read_uint64 = Lib_s2n.s2n_stuffer_read_uint64;

    s2n_stuffer_write_uint8 = Lib_s2n.s2n_stuffer_write_uint8;
    s2n_stuffer_write_uint16 = Lib_s2n.s2n_stuffer_write_uint16;
    s2n_stuffer_write_uint24 = Lib_s2n.s2n_stuffer_write_uint24;
    s2n_stuffer_write_uint32 = Lib_s2n.s2n_stuffer_write_uint32;
    --s2n_stuffer_write_uint64 = Lib_s2n.s2n_stuffer_write_uint64;

    -- copy one stuffer to another
    s2n_stuffer_copy = Lib_s2n.s2n_stuffer_copy;

    -- base64 read/write
    s2n_stuffer_read_base64 = Lib_s2n.s2n_stuffer_read_base64;
    s2n_stuffer_write_base64 = Lib_s2n.s2n_stuffer_write_base64;
}

return exports
