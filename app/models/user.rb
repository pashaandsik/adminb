# frozen_string_literal: true

class User < ActiveRecord::Base

  scope :active, -> { where(active: true) }

  attr_encrypted :email
  attr_encrypted :first_name
  attr_encrypted :last_name

  MIN_PASSWORD_LENGTH = 6

  def check_password?(password)
    SCrypt::Password.new(password_hash) == password
  end

  def password=(value)
    @password = value
    self.password_hash = SCrypt::Password.create(value) if value.present?
  end

  def email=(value)
    super(value.chomp.downcase)
  end

  def first_name=(value)
    return unless value
    value = value.chomp.match(/[\s\-]/) do |d|
      value.chomp.split(d[0]).map(&:capitalize) * d[0]
    end || value.capitalize
    super(value)
  end

  def last_name=(value)
    return unless value
    value = value.chomp.match(/[\s\-]/) do |d|
      value.chomp.split(d[0]).map(&:capitalize) * d[0]
    end || value.capitalize
    super(value)
  end
end
