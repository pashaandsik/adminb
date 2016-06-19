# frozen_string_literal: true
module Admin
  module Forms
    class AdminUser
      include ActiveModel::Validations
      include FormMixin

      attr_reader :admin_user

      attribute :email,       String
      attribute :password,    String
      attribute :role,        String
      attribute :active,      Boolean


      validates :email,     presence: true, email: true
      validates :password,  presence: true, unless: -> { persisted? }
      validates :password,  admin_password: true, if: -> { password.present? }
      validates :role,      presence: true, inclusion: { in: Admin::Ability.rights.keys }

      def self.find(id)
        new(entity: Admin::AdminUser.find(id))
      end

      def create!
        return false unless valid?
        @entity = Admin::AdminUser.create!(attrs_with_conditions)
      end

      def update!(params)
        self.attributes = params
        return false unless valid?
        @entity.update!(attrs_with_conditions)
      end

      def email=(email)
        @email = email.downcase
      end

      private

      def assign_attributes(attrs)
        self.attributes = attrs.merge(email: @entity.email.dup)
      end

      def attrs_with_conditions
        attributes.except(:entity)
      end
    end
  end
end
