module  FormMixin
  extend ActiveSupport::Concern

  included do
    include ActiveModel::Model
    include Virtus.model

    class << self
      attr_writer :form_name

      def model_name
        ActiveModel::Name.new(to_s, nil, form_name)
      end

      def form_name
        @form_name ||= ActiveSupport::Inflector.demodulize(to_s).sub(/Form\z/, "")
      end
    end

    attribute :entity, Object

    def persisted?
      entity.present?
    end

    def id
      entity&.id
    end

    def entity=(entity)
      @entity = entity
      assign_attributes(entity.attributes)
    end

    private

    def assign_attributes(attrs)
      self.attributes = attrs
    end
  end
end
