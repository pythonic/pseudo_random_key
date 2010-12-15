# encoding: UTF-8

# Copyright (c) 2010 Pythonic Pty Ltd
# http://www.pythonic.com.au/

module PseudoRandomKey
  module Base
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      # adds before_create callback to generate pseudo random keys.
      def pseudo_random_key
        include PseudoRandomKey::Base::InstanceMethods
        before_create :set_pseudo_random_key
      end
    end

    module InstanceMethods
      # generates pseudo random surrogate key for model instance.
      def set_pseudo_random_key
        self.id = PseudoRandomKey.next_pseudo_random_key_id
      end
    end
  end
end

ActiveRecord::Base.send :include, PseudoRandomKey::Base
