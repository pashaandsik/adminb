# module ActiveRecord
#   module QueryMethods
#     extend ActiveSupport::Concern
#
#     def build_where(opts, other = [])
#       case opts
#       when String, Array
#         [@klass.send(:sanitize_sql, other.empty? ? opts : ([opts] + other))]
#       when Hash
#           # opts = PredicateBuilder.resolve_column_aliases(klass, opts)
#           #
#           # tmp_opts, bind_values = create_binds(opts)
#           # self.bind_values += bind_values
#           #
#           # attributes = @klass.send(:expand_hash_conditions_for_aggregates, tmp_opts)
#           # add_relations_to_bind_values(attributes)
#           #
#           # PredicateBuilder.build_from_hash(klass, attributes, table)
#         opts = PredicateBuilder.resolve_column_aliases(klass, opts)
#
#         tmp_opts, bind_values = create_binds(opts)
#         self.bind_values += bind_values
#
#         attributes = @klass.send(:expand_hash_conditions_for_aggregates, tmp_opts)
#
#         (attributes.keys & encrypted_attributes.keys).each do |key|
#           new_key = encrypted_attributes[key]
#
#           value = if attributes[key].is_a?(Array)
#                     attributes[key].map { |val| SymmetricEncryption.encrypt(val) }
#                   else
#                     SymmetricEncryption.encrypt(attributes[key])
#                   end
#
#           attributes[new_key] = value
#           attributes.delete(key)
#         end
#
#         add_relations_to_bind_values(attributes)
#
#         PredicateBuilder.build_from_hash(klass, attributes, table)
#       else
#         [opts]
#       end
#     end
#   end
# end
#
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
# module ActiveRecord
#   module Relation::QueryMethods
#     extend ActiveSupport::Concern
#
#     # include ActiveModel::ForbiddenAttributesProtection
#     class WhereChain
#       include ActiveModel::ForbiddenAttributesProtection
#
#       def where!(opts, *rest) # :nodoc:
#         opts = sanitize_forbidden_attributes(opts)
#         abort if true
#         references!(PredicateBuilder.references(opts)) if Hash === opts
#         self.where_clause += where_clause_factory.build(opts, rest)
#         self
#       end
#     end
#   end
# end