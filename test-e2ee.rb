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
puts "ALICE Private KEY #{alice_keys.private_key}"

#alice_encrypted_priv_key = Aes256GcmEncryption.encrypt(alice_keys.private_key.to_s, alice_password)

# puts "Alice encrypted private key #{alice_encrypted_priv_key}"

# Decrypt Alice private key 
#alice_dec_priv_key = Aes256GcmEncryption.decrypt(alice_encrypted_priv_key, alice_password)


alice_pem = alice_keys.to_pem
puts "alice pem #{alice_pem}"

alice_encrypted_pem = Aes256GcmEncryption.encrypt(alice_pem, alice_password)
puts "alice pem encrypted #{alice_encrypted_pem}"
alice_decrypted_pem = Aes256GcmEncryption.decrypt(alice_encrypted_pem, alice_password)
puts "alice pem decrypted #{alice_decrypted_pem}"

new_instance_alice = OpenSSL::PKey::EC.new(alice_decrypted_pem)
puts "new instance alice #{new_instance_alice}"
puts "new instance alice private key #{new_instance_alice.private_key}"

#puts "Alice decrypt private key #{alice_dec_priv_key}"
#puts "Alice private and decrypt are equal #{alice_keys.private_key.to_s == alice_dec_priv_key}"


## Save and Re-use pub key
puts "Alice pub key #{alice_keys.public_key}"

alice_pub_key_string = alice_keys.public_key.to_bn.to_s
## Save alice_pub_key_string
puts "Saved : Alice pub key string #{alice_pub_key_string}"


## Re-use alice_pub_key

alice_bn_pub_key = OpenSSL::BN.new(alice_pub_key_string)

new_group = OpenSSL::PKey::EC::Group.new('secp521r1')
new_alice_pub_key = OpenSSL::PKey::EC::Point.new(new_group, alice_bn_pub_key)
puts "Alice pub key hash #{new_alice_pub_key}" 
new_alice_pub_key_string = new_alice_pub_key.to_bn.to_s

puts "Alice pub key string #{new_alice_pub_key_string}"
p new_alice_pub_key_string == alice_pub_key_string

bob_keys.dh_compute_key(new_alice_pub_key)


## Save shared_key 
