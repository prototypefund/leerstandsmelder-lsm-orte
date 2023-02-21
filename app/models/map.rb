# frozen_string_literal: true

class Map < ApplicationRecord
  has_paper_trail
  resourcify
  extend Mobility
  translates :organisation, type: :string

  belongs_to :group, optional: true
  belongs_to :iconset, optional: true
  has_many :layers, dependent: :destroy
  has_many :people, dependent: :destroy
  has_many :places, through: :layers

  has_many :news_maps
  has_many :news, through: :news_maps

  has_one_attached :image, dependent: :destroy
  has_one_attached :backgroundimage, dependent: :destroy
  has_one_attached :favicon, dependent: :destroy

  validates :title, presence: true

  extend FriendlyId
  friendly_id :title, use: :history

  after_create :setup_map_role
  # after_create :setup_map_group
  after_create :setup_map_default_layer

  def setup_map_role
    r = Role.new
    r.name = 'moderator'
    r.resource_type = 'Map'
    r.resource_id = id
    r.save!
  end

  def setup_map_group
    g = Group.new
    g.title = title
    g.active = true
    g.save!

    self.group_id = g.id
    save!
  end

  def setup_map_default_layer
    layer = Layer.new

    layer.map = self

    layer.slug = slug
    layer.title = "#{title} DEFAULT"
    layer.subtitle = ''
    layer.text = ''
    layer.credits = ''
    layer.color = ''
    layer.mapcenter_lon = mapcenter_lon
    layer.mapcenter_lat = mapcenter_lat
    layer.created_at = created_at
    layer.updated_at = updated_at
    layer.published = true
    layer.zoom = zoom
    layer.public_submission = false

    layer.save!
  end

  def map_status
    # all basic map status
    basic = Status.where(basic: true)
    map_specific = Status.where(basic: false, map: id)
    (basic + map_specific)
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
