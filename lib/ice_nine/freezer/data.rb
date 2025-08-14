# encoding: utf-8

module IceNine
  class Freezer

    # A freezer class for handling Data objects
    class Data < Object

      # Deep Freeze a Data object
      #
      # @example
      #   Person = Data.define(:name, :age)
      #   person = Person.new(name: 'John', age: 30)
      #   frozen_person = IceNine::Freezer::Data.deep_freeze(person)
      #   frozen_person.name.frozen?  # => true
      #
      # @param [Data] data
      # @param [RecursionGuard] recursion_guard
      #
      # @return [Data]
      def self.guarded_deep_freeze(data, recursion_guard)
        super
        data.to_h.each_value do |value|
          Freezer.guarded_deep_freeze(value, recursion_guard)
        end
        data
      end

    end # Data
  end # Freezer
end # IceNine
