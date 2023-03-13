# frozen_string_literal: true

class Annotation < ApplicationRecord
  has_paper_trail

  belongs_to :place
  belongs_to :user, optional: true
  belongs_to :person, optional: true

  acts_as_taggable_on :tags

  has_one_attached :audio, dependent: :destroy
  has_many :images, as: :imageable, dependent: :destroy

  # validates :text, presence: true
  # validates :status, presence: true
  validate :check_audio_format

  scope :published, -> { where(published: true) }

  def person_name
    person.name.to_s if person
  end

  def audiolink
    ApplicationController.helpers.audio_link(audio) if audio
  end

  private

  def check_audio_format
    errors.add(:audio, 'format must be MP3.') if audio.attached? && !audio.content_type.in?(%w[audio/mpeg])
  end
end
