# encoding: UTF-8

# Copyright (c) 2010 Pythonic Pty Ltd
# http://www.pythonic.com.au/

require "openssl"

module PseudoRandomKey
  class << self
    # uses Blowfish cipher in (stateless) ECB mode.
    def init(key)
      @cipher = OpenSSL::Cipher::Cipher.new("BF-ECB")
      @cipher.key = key
      @cipher.encrypt
    end

    # returns given string, encrypted as string.
    def encrypt_string(string)
      @cipher.update(string)
    end

    # returns given 64-bit signed integer, encrypted as 64-bit signed integer.
    def encrypt_integer(integer)
      encrypt_string([integer].pack("q")).unpack("q").first
    end

    # returns next value from PostgreSQL sequence generator.
    def next_pseudo_random_key_sequence_value
      ActiveRecord::Base.connection.select_value(%(SELECT nextval('pseudo_random_key_sequence');)).to_i
    end

    # returns next pseudo random key.
    def next_pseudo_random_key_id
      encrypt_integer(next_pseudo_random_key_sequence_value)
    end
  end
end
