# Store original error type in validation message (for client API error codes).
module ErrorMessages
  class ErrorMessage
    attr_reader :error_type, :message
    delegate :==, :as_json, :to_s, to: :message

    def initialize(error_type:, message:)
      @error_type = error_type
      @message = message
    end

    def method_missing(*args)
      message.send(*args)
    end
  end

  def generate_message(attribute, type = :invalid, options = {})
    type = options[:message] if options[:message].is_a?(Symbol)

    ErrorMessage.new(error_type: type, message: super)
  end
end

ActiveModel::Errors.prepend(ErrorMessages)
