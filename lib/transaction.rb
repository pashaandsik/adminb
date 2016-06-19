# frozen_string_literal: true
module Transaction
  DEFAULT_TIMEOUT = APP_CONFIG["lock_timeout"].to_i

  class << self
    def transaction
      ActiveRecord::Base.transaction { yield }
    end

    def with_timeout(timeout = nil)
      transaction { timeout(timeout) { yield } }
    end

    def with_lock(lock_name, with_timeout = true, timeout = nil)
      if with_timeout
        transaction { timeout(timeout) { lock(lock_name) { yield } } }
      else
        transaction { lock(lock_name) { yield } }
      end
    end

    private

    def timeout(timeout = nil)
      timeout = timeout.to_i
      timeout = DEFAULT_TIMEOUT unless timeout > 0
      Timeout.timeout(timeout, Transaction::TimeoutError) { yield }
    end

    def lock(lock_name)
      ActiveRecord::Base.with_advisory_lock(lock_name) { yield }
    end
  end

  class TimeoutError < StandardError
  end
end
