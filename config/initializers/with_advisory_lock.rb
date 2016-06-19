module WithAdvisoryLock
  class PostgreSQL < Base
    def try_lock
      execute_successful?('pg_try_advisory_xact_lock')
    end

    def release_lock
      true
    end
  end
end
