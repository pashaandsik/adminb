# frozen_string_literal: true
module Admin
  class Ability
    AccessDenied = Class.new(StandardError)

    class << self
      def rights
        @rights ||= Hash.new { |hash, key| hash[key] = {} }
      end

      def add_right(roles, action, subject, options = {})
        [*roles].each { |role| rights[role.to_s][[action, subject]] = options }
      end

      def describe_right(right)
        key, options = right
        options[:title] || descriptions[key] || key.join(" ").titleize
      end

      def descriptions
        {
          %i[manage all]        => 'Manage All',
          %i[view basic_info]   => 'View bisic info',
        }
      end
    end

    attr_reader :user

    def initialize(user)
      @user = user
    end

    def can?(action, subject, *args)
      return {} if user.admin?

      user_rights = self.class.rights.fetch(user.role)
      options = if [action, subject] == %i[edit users]
                  {} unless (editable_fields(:user, user.role) & args).empty?
                else
                  user_rights[[:manage, subject]] || user_rights[[action, subject]]
                end
      return unless options

      condition = options[:if]
      return {} unless condition

    end

    def cannot?(*params)
      !can?(*params)
    end

    def authorize!(*params)
      can?(*params) or raise AccessDenied, params.inspect
    end

    def editable_fields(entity, role)
      case entity.to_sym
      when :user
        case role.to_sym
        when :transport_manager, :info
          %i[docs_verified]
        when :admin
          %i[ blocked phone_verified email_verified docs_verified
         phone first_name last_name]
        else
          []
        end
      end
    end

    add_right :admin, :manage, :all # only used to show rights in user form
    add_right %i[info transport_manager], :view, :basic_info
  end
end