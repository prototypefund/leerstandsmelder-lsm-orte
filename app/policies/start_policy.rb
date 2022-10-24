# frozen_string_literal: true

class StartPolicy < ApplicationPolicy
  attr_reader :user

  def index
    true
  end

  def show?
    true
  end

  def settings?
    true
  end

  def edit_profile?
    true
  end
end
