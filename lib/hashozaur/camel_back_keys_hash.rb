module Hashozaur
  class CamelBackKeysHash

    def self.convert(object)
      new.to_camelback_keys(object)
    end

    # Recursively converts Rubyish snake_case hash keys to camelBack JSON-style
    # hash keys suitable for use with a JSON API.
    def to_camelback_keys(object)
      case object
      when Array
        object.map { |v| to_camelback_keys(v) }
      when Hash
        Hash[object.map { |k, v| [camelize_key(k), to_camelback_keys(v)] }]
      else
        object
      end
    end

    private

    def camelize_key(k)
      if k.is_a? Symbol
        camelize_back(k.to_s).to_sym
      elsif k.is_a? String
        camelize_back(k)
      else
        k
      end
    end

    def camelize_back(snake_word)
      word = camelize(snake_word)
      if word != snake_word
        word[0].downcase + word[1..-1]
      else
        snake_word
      end
    end

    def camelize(snake_word)
      snake_word.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
    end
  end
end
