module Hashozaur
  class CamelKeysHash

    def self.convert(object)
      new.to_camel_keys(object)
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

    def camelize_key(k)
      if k.is_a? Symbol
        camelize(k.to_s).to_sym
      elsif k.is_a? String
        camelize(k)
      else
        k
      end
    end

    def camelize(snake_word)
      snake_word.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
    end
  end
end
