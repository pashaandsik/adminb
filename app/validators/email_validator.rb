class EmailValidator < ActiveModel::Validator
  def validate(object)
    email = object.email.to_s.downcase
    case
    when email !~ /\A[a-z0-9][\w\.\+-]*[a-z0-9]@[a-z0-9][\w\.-]*[a-z0-9]\.[a-z][a-z\.]*[a-z]\z/
      object.errors.add :email, :invalid
    when !domain_valid?(email.match(/\@(.+)/)[1])
      object.errors.add :email, :not_found
    end
  end

  private

  def domain_valid?(domain)
    return true if Rails.env.test?
    Resolv::DNS.open do |dns|
      dns.timeouts = 1
      @mx = dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
    end
    @mx.size > 0
  end
end
