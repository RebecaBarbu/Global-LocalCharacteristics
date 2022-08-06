function h_decrypted = decryptHash(hash, Key)

Y_array = randerr(size(hash,2),64, 64/2, Key);
Y = uint64(bi2de(Y_array)');

% hash = double(hash);
h_decrypted = mod((hash - Y), 2^64);

end