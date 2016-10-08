require 'openssl'
require 'base64'

class AesEncryptDecrypt

  KEY = 'LOOONG_SECRET_KEY'
  ALGORITHM = 'AES-128-ECB'

  def self.encryption(msg)
    cipher = OpenSSL::Cipher.new(ALGORITHM)
    cipher.encrypt
    cipher.key = KEY
    crypt = cipher.update(msg) + cipher.final
    crypt_string = (Base64.encode64(crypt))
    return crypt_string
  rescue Exception => exc
    puts("Message for the encryption log file for message #{msg} = #{exc.message}")
  end

  def self.decryption(msg)
    cipher = OpenSSL::Cipher.new(ALGORITHM)
    cipher.decrypt
    cipher.key = KEY
    tempkey = Base64.decode64(msg)
    crypt = cipher.update(tempkey)
    crypt << cipher.final
    return crypt
  rescue Exception => exc
    puts ("Message for the decryption log file for message #{msg} = #{exc.message}")
  end

end