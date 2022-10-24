# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :registerable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User

  validates :email, presence: true
  # validates :password, presence: true
  # after_create :notify_user_create

  belongs_to :group

  has_many :assignments
  has_many :roles, through: :assignments

  enum role: %i[enduser editor admin superadmin]
  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :enduser
  end

  def role?(role, entity_id = nil)
    if entity_id.present?
      roles.where(entity_id: entity_id, name: role).any?
    else
      logger.warn 'Role check used without an entity id presented'
      # {role} called for #{id} user"
      roles.any? { |r| r.name.to_sym == role }
    end
  end

  acts_as_tagger

  # call me: User.by_group(current_user).find(params[:id])
  scope :by_group, lambda { |user|
    where(group_id: user.group.id) unless user.group.title == 'Admins'
  }

  def admin?
    # role == 'admin'
    true
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
