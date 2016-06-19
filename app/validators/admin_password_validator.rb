class AdminPasswordValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    value = value.to_s
    return true if value.blank?
    case
    when value.size < Admin::AdminUser::MIN_PASSWORD_LENGTH
      object.errors.add(attribute, :admin_too_short, count: Admin::AdminUser::MIN_PASSWORD_LENGTH)
    when value !~ /(?=.*[a-zа-я])(?=.*\d)(?=.*[\@\#\$\%\^\&\*\(\)\_\-\+\=]).*/i
      object.errors.add(attribute, :admin_invalid)
    end
  end
end
