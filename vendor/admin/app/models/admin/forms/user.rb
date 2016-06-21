# frozen_string_literal: true
module Admin
  module Forms
    class User
      include FormMixin

      attr_reader :knowledge, :controller

      delegate :current_user, to: :controller

      attribute :first_name,          String
      attribute :last_name,           String
      attribute :email,               String
      attribute :password,            String
      attribute :email_verified,      Boolean

      validates :first_name, :last_name, presence: true
      validates :email,     presence: true, email: true
      validates :password,  presence: true, unless: -> { persisted? }
      validates :password,  password: true, if: -> { password.present? }


      def self.find(id)
        new(entity: ::User.find(id))
      end

      def create!
        return false unless valid?
        @entity = ::User.create!(attrs_with_conditions)
      rescue ActiveRecord::RecordNotUnique => _error
        errors.add(:email, :taken)
        false
      end

      def update!(params)
        self.attributes = params
        return false unless valid?
        @entity.update!(attrs_with_conditions)
      rescue ActiveRecord::RecordNotUnique => _error
        errors.add(:email, :taken)
        false
      end

      def destroy!
        @entity.update!(active: false)
      end

      private

      def assign_attributes(attrs)
        self.attributes = attrs.merge(
            email: @entity.email.dup,
            last_name: @entity.last_name&.dup,
            first_name: @entity.first_name&.dup
        )
      end

      def attrs_with_conditions
        attributes.except(:entity)
      end
    end
  end
end
