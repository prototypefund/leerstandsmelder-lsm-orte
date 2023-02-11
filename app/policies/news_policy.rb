# frozen_string_literal: true

class NewsPolicy < ApplicationPolicy
  attr_reader :user, :news

  def initialize(user, news)
    @user = user
    @news = news
  end

  def index?
    true
  end

  def new?
    user.admin?
  end

  def edit?
    user.admin?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def show?
    user&.admin? || news.published?
  end

  def self.destroy?(user, news)
    new(user, news).destroy?
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user&.has_role?(:moderator, :any)
        scope.where(map: Map.with_role(:moderator, user).map(&:id))
      elsif user&.blank?
        scope.where(published: true)
      else
        scope.where(published: true)
      end
    end
  end
end
