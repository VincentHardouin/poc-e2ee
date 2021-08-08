$LOAD_PATH << '.'
require('openssl')
require('aes_256_gcm_encryption')

alice_keys = OpenSSL::PKey::EC.generate('secp521r1')
bob_keys = OpenSSL::PKey::EC.generate('secp521r1')

shared_key1 = alice_keys.dh_compute_key(bob_keys.public_key)
shared_key2 = bob_keys.dh_compute_key(alice_keys.public_key)

# Alice and Bob could use AES encryption with shared key to communicate 
p shared_key1 == shared_key2 #=> true

alice_password = 'pa$$worD'
bod_password = 'Pas$W0rd'
  

# Now you want store Alice private key 
# Encrypt Alice private key 
puts alice_keys.private_key

alice_encrypted_priv_key = Aes256GcmEncryption.encrypt(alice_keys.private_key.to_s, alice_password)

puts "Alice encrypted private key #{alice_encrypted_priv_key}"

# Decrypt Alice private key 
alice_dec_priv_key = Aes256GcmEncryption.decrypt(alice_encrypted_priv_key, alice_password)

puts "Alice decrypt private key #{alice_dec_priv_key}"
puts "Alice private and decrypt are equal #{alice_keys.private_key.to_s == alice_dec_priv_key}"

