class PasswordValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    value = value.to_s
    return true if value.blank?
    case
    when value.size < User::MIN_PASSWORD_LENGTH
      object.errors.add(attribute, :too_short, count: User::MIN_PASSWORD_LENGTH)
    when value !~ /(?=.*[a-zа-яё])(?=.*\d).*/i
      object.errors.add(attribute, :invalid)
    end
  end
end
