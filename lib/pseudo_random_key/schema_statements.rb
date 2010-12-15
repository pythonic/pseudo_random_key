# encoding: UTF-8

# Copyright (c) 2010 Pythonic Pty Ltd
# http://www.pythonic.com.au/

module PseudoRandomKey
  module SchemaStatements
    # creates PostgreSQL sequence generator using full 64-bit range.
    def create_pseudo_random_key_sequence
      execute %(CREATE SEQUENCE "pseudo_random_key_sequence" MINVALUE -9223372036854775808 MAXVALUE 9223372036854775807;)
    end

    def drop_pseudo_random_key_sequence
      execute %(DROP SEQUENCE "pseudo_random_key_sequence";)
    end
  end
end

ActiveRecord::ConnectionAdapters::AbstractAdapter.send :include, PseudoRandomKey::SchemaStatements
