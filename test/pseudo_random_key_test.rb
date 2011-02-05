# encoding: UTF-8

# Copyright (c) 2010 Pythonic Pty Ltd
# http://www.pythonic.com.au/

require "test_helper"

PseudoRandomKey.init("0123456789ABCDEF")

class PseudoRandomKeyTestMigration < ActiveRecord::Migration
  def self.up
    create_table :pseudo_random_key_test_objects do |t|
    end
    execute %(ALTER TABLE "pseudo_random_key_test_objects" ALTER COLUMN "id" TYPE "int8";)
  end

  def self.down
    drop_table :pseudo_random_key_test_objects
  end
end

PseudoRandomKeyTestMigration.migrate :up

at_exit do
  at_exit do
    PseudoRandomKeyTestMigration.migrate :down
  end
end

class PseudoRandomKeyTestObject < ActiveRecord::Base
  pseudo_random_key
end

class PseudoRandomKeyTest < Test::Unit::TestCase
  def with_sequence
    ActiveRecord::Migration.create_pseudo_random_key_sequence
    yield
  ensure
    ActiveRecord::Migration.drop_pseudo_random_key_sequence
  end

  def test_encrypt_string
    assert_equal [0xE0, 0x77, 0x6A, 0xC9, 0x8A, 0x3A, 0x81, 0x99], PseudoRandomKey.encrypt_string("01234567").bytes.to_a
    assert_equal [0xE0, 0x77, 0x6A, 0xC9, 0x8A, 0x3A, 0x81, 0x99], PseudoRandomKey.encrypt_string("01234567").bytes.to_a
  end

  def test_encrypt_integer
    assert_equal 0x3B6B6A263CD61D7D, PseudoRandomKey.encrypt_integer(0x0000000000000000)
    assert_equal 0x3B6B6A263CD61D7D, PseudoRandomKey.encrypt_integer(0x0000000000000000)
  end

  def test_next_pseudo_random_key_sequence_value
    with_sequence do
      ActiveRecord::Base.cache do
        assert_equal -9223372036854775808, PseudoRandomKey.next_pseudo_random_key_sequence_value
        assert_equal -9223372036854775807, PseudoRandomKey.next_pseudo_random_key_sequence_value
      end
    end
  end

  def test_next_pseudo_random_key_id
    with_sequence do
      assert_equal 6647456405651490659, PseudoRandomKey.next_pseudo_random_key_id
      assert_equal 7797065249773075692, PseudoRandomKey.next_pseudo_random_key_id
    end
  end

  def test_set_pseudo_random_key
    object = PseudoRandomKeyTestObject.new
    with_sequence do
      object.set_pseudo_random_key
      assert_equal 6647456405651490659, object.id
      object.set_pseudo_random_key
      assert_equal 7797065249773075692, object.id
    end
  end

  def test_pseudo_random_key
    with_sequence do
      object = PseudoRandomKeyTestObject.create
      assert_equal 6647456405651490659, object.id
      object = PseudoRandomKeyTestObject.create
      assert_equal 7797065249773075692, object.id
    end
  end
end
