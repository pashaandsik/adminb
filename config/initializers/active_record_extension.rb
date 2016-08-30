module ActiveRecord
  class Relation
    class WhereClauseFactory # :nodoc:
      def initialize(klass, predicate_builder)
        @klass = klass
        @predicate_builder = predicate_builder
      end

      def build(opts, other)
        binds = []

        case opts
          when String, Array
            parts = [klass.send(:sanitize_sql, other.empty? ? opts : ([opts] + other))]
          when Hash


            attributes = predicate_builder.resolve_column_aliases(opts)
            attributes = klass.send(:expand_hash_conditions_for_aggregates, attributes)


            (attributes.keys & klass.encrypted_attributes.keys).each do |key|
              new_key = klass.encrypted_attributes[key]

              value = if attributes[key].is_a?(Array)
                        attributes[key].map { |val| SymmetricEncryption.encrypt(val) }
                      else
                        SymmetricEncryption.encrypt(attributes[key])
                      end

              attributes[new_key] = value
              attributes.delete(key)
            end


            attributes.stringify_keys!

            attributes, binds = predicate_builder.create_binds(attributes)

            parts = predicate_builder.build_from_hash(attributes)
          when Arel::Nodes::Node
            parts = [opts]
          else
            raise ArgumentError, "Unsupported argument type: #{opts} (#{opts.class})"
        end

        WhereClause.new(parts, binds)
      end

      protected

      attr_reader :klass, :predicate_builder
    end
  end
end
