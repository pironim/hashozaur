module Hashozaur
  class CamelKeysHash

    def self.to_camelback_keys(object)
      new.to_camelback_keys(object)
    end

    def self.to_camel_keys(object)
      new.to_camel_keys(object)
    end

    # Recursively converts Rubyish snake_case hash keys to camelBack JSON-style
    # hash keys suitable for use with a JSON API.
    def to_camelback_keys(object)
      case object
      when Array
        object.map { |v| to_camelback_keys(v) }
      when Hash
        Hash[object.map { |k, v| [camelize_key(k, false), to_camelback_keys(v)] }]
      else
        object
      end
    end

    # Recursively converts Rubyish snake_case hash keys to CamelCase JSON-style
    # hash keys suitable for use with a JSON API.
    def to_camel_keys(object)
      case object
      when Array
        object.map { |v| to_camel_keys(v) }
      when Hash
        Hash[object.map { |k, v| [camelize_key(k), to_camel_keys(v)] }]
      else
        object
      end
    end

    private

    # TODO remove boolean param as a code smell
    def camelize_key(k, first_upper = true)
      if k.is_a? Symbol
        camelize(k.to_s, first_upper).to_sym
      elsif k.is_a? String
        camelize(k, first_upper)
      else
        k
      end
    end

    def camelize(snake_word, first_upper = true)
      if first_upper
        snake_word.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
      else
        snake_word.chars.first + camelize(snake_word)[1..-1]
      end
    end
  end
end
