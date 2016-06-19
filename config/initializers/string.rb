require "unicode"

class String
  def downcase
    Unicode.downcase(self)
  end

  def downcase!
    replace downcase
  end

  def upcase
    Unicode.upcase(self)
  end

  def upcase!
    replace upcase
  end

  def capitalize
    Unicode.capitalize(self)
  end

  def capitalize!
    replace capitalize
  end
end
