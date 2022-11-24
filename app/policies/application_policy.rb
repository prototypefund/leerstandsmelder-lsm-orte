# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    # raise Pundit::NotAuthorizedError, 'must be logged in' unless user

    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    user&.admin?
  end

  def edit?
    update?
  end

  def destroy?
    user&.admin?
  end

  def admin?
    @user.admin?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    def initialize(user, scope)
      # raise Pundit::NotAuthorizedError, 'must be logged in' unless user

      @user = user
      @scope = scope
    end

    def resolve
      scope
      # raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
