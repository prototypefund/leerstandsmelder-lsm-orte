# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :registerable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  include ModelAuthorization

  validates :email, presence: true
  # validates :password, presence: true
  validates :role,  presence: true,
                    inclusion: { in: Ability.role_symbols.map(&:to_s) }

  # after_create :notify_user_create

  belongs_to :group

  acts_as_tagger

  # call me: User.by_group(current_user).find(params[:id])
  scope :by_group, lambda { |user|
    where(group_id: user.group.id) unless user.group.title == 'Admins'
  }

  #def jwt_payload
  #  super.merge('foo' => 'bar')
  #end
  

  def admin?
    role == 'admin'
  end

  def self.current_ability=(ability)
    Thread.current[:ability] = ability
  end

  def self.current_ability
    Thread.current[:ability]
  end

  def self.perform_authorization?
    !!current_ability
  end

  private

  def notify_user_create
    ApplicationMailer.notify_user_created(self).deliver_now
    ApplicationMailer.notify_admin_user_created(self).deliver_now
  end
end
