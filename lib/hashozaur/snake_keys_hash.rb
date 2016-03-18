module Hashozaur
  class SnakeKeysHash

    def self.convert(object)
      new.convert(object)
    end

    # Recursively converts CamelCase and camelBack JSON-style hash keys to
    # Rubyish snake_case, suitable for use during instantiation of Ruby
    # model attributes.
    def convert(object)
      case object
      when Array
        object.map { |v| convert(v) }
      when Hash
        snake_hash(object)
      else
        object
      end
    end

    private

    def snake_hash(object)
      Hash[object.map { |k, v| [underscore_key(k), convert(v)] }]
    end

    def underscore_key(k)
      if k.is_a? Symbol
        underscore(k.to_s).to_sym
      elsif k.is_a? String
        underscore(k)
      else
        k
      end
    end

    def underscore(string)
      string.gsub(/::/, '/')
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .tr('-', '_')
        .downcase
    end
  end
end
