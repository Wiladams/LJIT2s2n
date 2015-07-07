local ffi = require("ffi")

ffi.cdef[[
typedef enum {
    S2N_ERR_OK] = 
    S2N_ERR_KEY_INIT] = 
    S2N_ERR_ENCRYPT] = 
    S2N_ERR_DECRYPT] = 
    S2N_ERR_MEMSET] = 
    S2N_ERR_MEMCPY] = 
    S2N_ERR_REALLOC] = 
    S2N_ERR_MLOCK] = 
    S2N_ERR_FSTAT] = 
    S2N_ERR_OPEN] = 
    S2N_ERR_MMAP] = 
    S2N_ERR_NULL] = 
    S2N_ERR_CLOSED] = 
    S2N_ERR_SAFETY] = 
    S2N_ERR_NOT_INITIALIZED] = 
    S2N_ERR_RANDOM_UNITIALIZED] = 
    S2N_ERR_OPEN_RANDOM] = 
    S2N_ERR_RESIZE_STATIC_STUFFER] = 
    S2N_ERR_RESIZE_TAINTED_STUFFER] = 
    S2N_ERR_STUFFER_OUT_OF_DATA] = 
    S2N_ERR_STUFFER_IS_FULL] = 
    S2N_ERR_INVALID_BASE64] = 
    S2N_ERR_INVALID_PEM] = 
    S2N_ERR_DH_COPYING_PARAMETERS] = 
    S2N_ERR_DH_COPYING_PUBLIC_KEY] = 
    S2N_ERR_DH_GENERATING_PARAMETERS] = 
    S2N_ERR_DH_PARAMS_CREATE] = 
    S2N_ERR_DH_SERIAZING] = 
    S2N_ERR_DH_SHARED_SECRET] = 
    S2N_ERR_DH_WRITING_PUBLIC_KEY] = 
    S2N_ERR_DH_FAILED_SIGNING] = 
    S2N_ERR_DH_TOO_SMALL] = 
    S2N_ERR_INVALID_PKCS3] = 
    S2N_ERR_HASH_DIGEST_FAILED] = 
    S2N_ERR_HASH_INIT_FAILED] = 
    S2N_ERR_HASH_INVALID_ALGORITHM] = 
    S2N_ERR_HASH_UPDATE_FAILED] = 
    S2N_ERR_HMAC_INVALID_ALGORITHM] = 
    S2N_ERR_SIZE_MISMATCH] = 
    S2N_ERR_DECODE_CERTIFICATE] = 
    S2N_ERR_DECODE_PRIVATE_KEY] = 
    S2N_ERR_KEY_MISMATCH] = 
    S2N_ERR_NOMEM] = 
    S2N_ERR_SIGN] = 
    S2N_ERR_VERIFY_SIGNATURE] = 
    S2N_ERR_ALERT_PRESENT] = 
    S2N_ERR_ALERT] = 
    S2N_ERR_CBC_VERIFY] = 
    S2N_ERR_CIPHER_NOT_SUPPORTED] = 
    S2N_ERR_BAD_MESSAGE] = 
    S2N_ERR_INVALID_SIGNATURE_ALGORITHM] = 
    S2N_ERR_INVALID_KEY_EXCHANGE_ALGORITHM] = 
    S2N_ERR_NO_CERTIFICATE_IN_PEM] = 
    S2N_ERR_NO_ALERT] = 
    S2N_ERR_CLIENT_MODE] = 
    S2N_ERR_SERVER_NAME_TOO_LONG] = 
    S2N_ERR_CLIENT_MODE_DISABLED] = 
    S2N_ERR_HANDSHAKE_STATE] = 
    S2N_ERR_FALLBACK_DETECTED] = 
    S2N_ERR_INVALID_CIPHER_PREFERENCES] = 
    S2N_ERR_APPLICATION_PROTOCOL_TOO_LONG] = 
    S2N_ERR_NO_APPLICATION_PROTOCOL] = 
    S2N_ERR_DRBG] = 
    S2N_ERR_DRBG_REQUEST_SIZE] = 
    S2N_ERR_ECDHE_GEN_KEY] = 
    S2N_ERR_ECDHE_SHARED_SECRET] = 
    S2N_ERR_ECDHE_UNSUPPORTED_CURVE] = 
    S2N_ERR_ECDHE_SERIALIZING] = 
} s2n_error;
]]

local errnos = {
    [ffi.C.S2N_ERR_OK] =  "no error" ;
    [ffi.C.S2N_ERR_KEY_INIT] =  "error initializing encryption key" ;
    [ffi.C.S2N_ERR_ENCRYPT] =  "error encrypting data" ;
    [ffi.C.S2N_ERR_DECRYPT] =  "error decrypting data" ;
    [ffi.C.S2N_ERR_MEMSET] =   "error calling memset" ;
    [ffi.C.S2N_ERR_MEMCPY] =   "error calling memcpy" ;
    [ffi.C.S2N_ERR_REALLOC] =  "error calling realloc" ;
    [ffi.C.S2N_ERR_MLOCK] =    "error calling mlock" ;
    [ffi.C.S2N_ERR_FSTAT] =    "error calling fstat" ;
    [ffi.C.S2N_ERR_OPEN] =     "error calling open" ;
    [ffi.C.S2N_ERR_MMAP] =     "error calling mmap" ;
    [ffi.C.S2N_ERR_NULL] =     "NULL pointer encountered" ;
    [ffi.C.S2N_ERR_CLOSED] =   "connection is closed" ;
    [ffi.C.S2N_ERR_SAFETY] =   "a safety check failed" ;
    [ffi.C.S2N_ERR_NOT_INITIALIZED] =   "s2n not initialized" ;
    [ffi.C.S2N_ERR_RANDOM_UNITIALIZED] =  "s2n enctropy not initialized" ;
    [ffi.C.S2N_ERR_OPEN_RANDOM] =  "error opening urandom" ;
    [ffi.C.S2N_ERR_RESIZE_STATIC_STUFFER] =  "cannot resize a static stuffer" ;
    [ffi.C.S2N_ERR_RESIZE_TAINTED_STUFFER] =  "cannot resize a tainted stuffer" ;
    [ffi.C.S2N_ERR_STUFFER_OUT_OF_DATA] =  "stuffer is out of data" ;
    [ffi.C.S2N_ERR_STUFFER_IS_FULL] =  "stuffer is full" ;
    [ffi.C.S2N_ERR_INVALID_BASE64] =  "invalid base64 encountered" ;
    [ffi.C.S2N_ERR_INVALID_PEM] =  "invalid PEM encountered" ;
    [ffi.C.S2N_ERR_DH_COPYING_PARAMETERS] =  "error copying Diffie-Hellman parameters" ;
    [ffi.C.S2N_ERR_DH_COPYING_PUBLIC_KEY] =  "error copying Diffie-Hellman public key" ;
    [ffi.C.S2N_ERR_DH_GENERATING_PARAMETERS] =  "error generating Diffie-Hellman parameters" ;
    [ffi.C.S2N_ERR_DH_PARAMS_CREATE] =  "error creating Diffie-Hellman parameters" ;
    [ffi.C.S2N_ERR_DH_SERIAZING] =  "error serializing Diffie-Hellman parameters" ;
    [ffi.C.S2N_ERR_DH_SHARED_SECRET] =  "error computing Diffie-Hellman shared secret" ;
    [ffi.C.S2N_ERR_DH_WRITING_PUBLIC_KEY] =  "error writing Diffie-Hellman public key" ;
    [ffi.C.S2N_ERR_DH_FAILED_SIGNING] =  "error signing Diffie-Hellman values" ;
    [ffi.C.S2N_ERR_DH_TOO_SMALL] =  "Diffie-Hellman parameters are too small" ;
    [ffi.C.S2N_ERR_INVALID_PKCS3] =  "invalid PKCS3 encountered" ;
    [ffi.C.S2N_ERR_HASH_DIGEST_FAILED] =  "failed to create hash digest" ;
    [ffi.C.S2N_ERR_HASH_INIT_FAILED] =  "error initializing hash" ;
    [ffi.C.S2N_ERR_HASH_INVALID_ALGORITHM] =  "invalid hash algorithm" ;
    [ffi.C.S2N_ERR_HASH_UPDATE_FAILED] =  "error updating hash" ;
    [ffi.C.S2N_ERR_HMAC_INVALID_ALGORITHM] =  "invalid HMAC algorithm" ;
    [ffi.C.S2N_ERR_SIZE_MISMATCH] =  "size mismatch" ;
    [ffi.C.S2N_ERR_DECODE_CERTIFICATE] =  "error decoding certificate" ;
    [ffi.C.S2N_ERR_DECODE_PRIVATE_KEY] =  "error decoding private key" ;
    [ffi.C.S2N_ERR_KEY_MISMATCH] =  "public and private key do not match" ;
    [ffi.C.S2N_ERR_NOMEM] =  "no memory" ;
    [ffi.C.S2N_ERR_SIGN] =  "error signing data"  ;
    [ffi.C.S2N_ERR_VERIFY_SIGNATURE] =  "error verifying signature" ;
    [ffi.C.S2N_ERR_ALERT_PRESENT] =  "TLS alert is already pending" ;
    [ffi.C.S2N_ERR_ALERT] =  "TLS alert received" ;
    [ffi.C.S2N_ERR_CBC_VERIFY] =  "Failed CBC verification" ;
    [ffi.C.S2N_ERR_CIPHER_NOT_SUPPORTED] =  "Cipher is not supported" ;
    [ffi.C.S2N_ERR_BAD_MESSAGE] =  "Bad message encountered" ;
    [ffi.C.S2N_ERR_INVALID_SIGNATURE_ALGORITHM] =  "Invalid signature algorithm" ;
    [ffi.C.S2N_ERR_INVALID_KEY_EXCHANGE_ALGORITHM] =  "Invaid key exchange algorithm" ;
    [ffi.C.S2N_ERR_NO_CERTIFICATE_IN_PEM] =  "No certificate in PEM" ;
    [ffi.C.S2N_ERR_NO_ALERT] =  "No Alert present" ;
    [ffi.C.S2N_ERR_CLIENT_MODE] =  "operation not allowed in client mode" ;
    [ffi.C.S2N_ERR_SERVER_NAME_TOO_LONG] =  "server name is too long" ;
    [ffi.C.S2N_ERR_CLIENT_MODE_DISABLED] =  "client connections not allowed" ;
    [ffi.C.S2N_ERR_HANDSHAKE_STATE] =  "Invalid handshake state encountered" ;
    [ffi.C.S2N_ERR_FALLBACK_DETECTED] =  "TLS fallback detected" ;
    [ffi.C.S2N_ERR_INVALID_CIPHER_PREFERENCES] =  "Invalid Cipher Preferences version" ;
    [ffi.C.S2N_ERR_APPLICATION_PROTOCOL_TOO_LONG] =  "Application protocol name is too long" ;
    [ffi.C.S2N_ERR_NO_APPLICATION_PROTOCOL] =  "No supported application protocol to negotiate" ;
    [ffi.C.S2N_ERR_DRBG] =  "Error using Determinstic Random Bit Generator" ;
    [ffi.C.S2N_ERR_DRBG_REQUEST_SIZE] =  "Request for too much entropy" ;
    [ffi.C.S2N_ERR_ECDHE_GEN_KEY] =  "Failed to generate an ECDHE key" ;
    [ffi.C.S2N_ERR_ECDHE_SHARED_SECRET] =  "Error computing ECDHE shared secret" ;
    [ffi.C.S2N_ERR_ECDHE_UNSUPPORTED_CURVE] =  "Unsupported EC curve was presented during an ECDHE handshake" ;
    [ffi.C.S2N_ERR_ECDHE_SERIALIZING] =  "Error serializing ECDHE public" ;
}

local function errnoToString(errno)
    return errnos[errno] or "UNKNOWN ERROR: "..tostring(errno);
end

local exports = {
    errnos = errnos;

    -- local functions
    errnoToString = errnoToString;
}

return exports
