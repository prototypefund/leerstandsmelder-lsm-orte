# frozen_string_literal: true

module ImagesHelper
  def itype_for_select
    [['Image (default)', 'image'], %w[Graphics graphics]]
  end

  def thumb_url(file)
    return unless file.attached?

    filename = ActiveStorage::Blob.service.path_for(file.key)
    return unless File.exist?(filename)

    begin
      polymorphic_url(file.variant(resize: '100x100').processed)
    rescue StandardError
      puts "the file can't be opened or is corrupted: #{filename}"
    end
  end

  def image_url(file)
    return unless file.attached?

    filename = ActiveStorage::Blob.service.path_for(file.key)
    return unless File.exist?(filename)

    begin
      polymorphic_url(file.variant(resize: '800x800').processed)
    rescue StandardError
      puts "the file can't be opened or is corrupted: #{filename}"
    end
  end

  def image_path(file)
    return unless file.attached?

    filename = ActiveStorage::Blob.service.path_for(file.key)
    return unless File.exist?(filename)

    begin
      polymorphic_url(file.variant(resize: '800x800').processed)
    rescue StandardError
      puts "the file can't be opened or is corrupted: #{filename}"
    end
  end

  def image_linktag(file, title = '')
    return unless file.attached?

    filename = ActiveStorage::Blob.service.path_for(file.key)
    return unless File.exist?(filename)

    "<img src=\"#{polymorphic_url(file.variant(resize: '800x800').processed)}\" title=\"#{title.present? ? title : ''}\">".html_safe
  end
end
