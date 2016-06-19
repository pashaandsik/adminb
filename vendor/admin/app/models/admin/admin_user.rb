# frozen_string_literal: true
module Admin
  class AdminUser < ActiveRecord::Base
    self.table_name = "admin_users"
    scope :active,        -> { where(active: true) }
    scope :inactive,      -> { where(active: false) }

    MIN_PASSWORD_LENGTH = 10

    attr_encrypted :email, :full_name

    attr_reader :password


    def check_password?(password)
      SCrypt::Password.new(password_hash) == password
    end

    def password=(value)
      @password = value
      self.password_hash = SCrypt::Password.create(value) if value.present?
    end

    def email=(value)
      value.downcase! if value
      super
    end

    def admin?
      role.to_sym == :admin
    end
  end
end