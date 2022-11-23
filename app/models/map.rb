# frozen_string_literal: true

class Map < ApplicationRecord
  resourcify
  belongs_to :group, optional: true
  belongs_to :iconset, optional: true
  has_many :layers, dependent: :destroy
  has_many :people, dependent: :destroy
  has_many :places, through: :layers

  has_one_attached :image, dependent: :destroy
  has_one_attached :backgroundimage, dependent: :destroy
  has_one_attached :favicon, dependent: :destroy

  validates :title, presence: true

  extend FriendlyId
  friendly_id :title, use: :slugged

  after_create :setup_map_role

  def setup_map_role
    r = Role.new
    r.name = "moderator"
    r.resource_type = "Map"
    r.resource_id = id
    r.save!
  end

  # call me: Map.by_user(current_user).find(params[:id])
  scope :by_user, lambda { |user|
    if user.group && user.group.active
      where(group_id: user.group.id) unless user.group.title == 'Admins'
    else
      where(group_id: -1) unless user.group && user.group.title == 'Admins'
    end
  }

  scope :sorted, -> { order(title: :asc) }

  scope :published, -> { where(published: true) }

  def image_link
    ApplicationController.helpers.image_url(image) if image&.attached?
  end

  def self.first
    order('maps.created_at').first
  end

  def self.last
    order('maps.created_at DESC').first
  end
end
