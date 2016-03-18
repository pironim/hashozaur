require "hashozaur/version"

require "hashozaur/camel_keys_hash"
require "hashozaur/snake_keys_hash"

module Hashozaur

  def self.to_snake_case(object)
    SnakeKeysHash.convert(object)
  end

  def self.to_camel_case(object)
    CamelKeysHash.to_camel_keys(object)
  end

  def self.to_camel_back_case(object)
    CamelKeysHash.to_camelback_keys(object)
  end

end
