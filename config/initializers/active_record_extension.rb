module ActiveRecord
  module QueryMethods
    extend ActiveSupport::Concern

    def build_where(opts, other = [])
      case opts
      when String, Array
        [@klass.send(:sanitize_sql, other.empty? ? opts : ([opts] + other))]
      when Hash
        opts = PredicateBuilder.resolve_column_aliases(klass, opts)

        tmp_opts, bind_values = create_binds(opts)
        self.bind_values += bind_values

        attributes = @klass.send(:expand_hash_conditions_for_aggregates, tmp_opts)

        (attributes.keys & encrypted_attributes.keys).each do |key|
          new_key = encrypted_attributes[key]

          value = if attributes[key].is_a?(Array)
                    attributes[key].map { |val| SymmetricEncryption.encrypt(val) }
                  else
                    SymmetricEncryption.encrypt(attributes[key])
                  end

          attributes[new_key] = value
          attributes.delete(key)
        end

        add_relations_to_bind_values(attributes)

        PredicateBuilder.build_from_hash(klass, attributes, table)
      else
        [opts]
      end
    end
  end
end
