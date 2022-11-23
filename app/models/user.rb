# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :registerable
  devise :database_authenticatable, :confirmable, :registerable, :lockable,
         :timeoutable, :recoverable, :rememberable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User

  validates :email, presence: true
  # validates :password, presence: true
  # after_create :notify_user_create

  belongs_to :group, required: false

  after_create :assign_default_role

  def assign_default_role
    add_role(:enduser) if roles.blank?
  end

  acts_as_tagger

  # call me: User.by_group(current_user).find(params[:id])
  scope :by_group, lambda { |user|
    if user.group
      where(group_id: user.group.id) unless user.group.title == 'Admins'
    else
      where(group_id: false)
    end
  }

  def admin?
    has_role? :admin
  end

  def role_keys
    roles.map do |r|
      if r.resource_type.blank?
        r.name
      else
        "#{r.name}_#{r.resource_type.downcase}_#{r.resource_id}"
      end
    end
  end

  # def self.current_ability=(ability)
  #   Thread.current[:ability] = ability
  # end

  # def self.current_ability
  #   Thread.current[:ability]
  # end

  # def self.perform_authorization?
  #   !!current_ability
  # end

  private

  def notify_user_create
    ApplicationMailer.notify_user_created(self).deliver_now
    ApplicationMailer.notify_admin_user_created(self).deliver_now
  end
end
