# frozen_string_literal: true

namespace :migration do
  desc 'migrate everything'
  task all: :environment do
    log('#################################')
    log('LSM Migration mongodb -> postgres')
    log('#################################')
    Rake::Task['migration:regions'].invoke
    log('#################################')
    Rake::Task['migration:users'].invoke
    log('#################################')
    Rake::Task['migration:locations'].invoke
    log('#################################')
    Rake::Task['migration:comments'].invoke
    log('#################################')
    Rake::Task['migration:images'].invoke
    log('#################################')
  end

  desc 'migrate regions'
  task regions: :environment do
    log('Starting task to migrate regions => maps')

    start_time = Time.now
    regions = Mongodb::Region.collection.find.to_a

    count = 0
    rescue_count = 0
    regions.each do |reg|
      log('-----------------------------------')
      log("Region: #{reg['title']} - #{reg['uuid']}")
      log(reg.inspect)
      next if Map.exists?(reg['uuid'])

      log("Lets go: #{reg['title']} - #{reg['uuid']}")
      ActiveRecord::Base.transaction do
        group = Group.new

        group.title = reg['title']

        group.save!

        map = Map.new

        map.group = group

        map.id = reg['uuid']
        map.slug = reg['slug']
        map.title = reg['title']
        map.mapcenter_lon = reg['lonlat'][0]
        map.mapcenter_lat = reg['lonlat'][1]
        map.created_at = reg['created']
        map.updated_at = reg['updated']
        map.published = !reg['hide']
        map.zoom = reg['zoom']

        begin
          map.save!
        rescue StandardError => e
          puts e.inspect
          rescue_count += 1
          next
        end

        layer = Layer.new
        layer.map = map

        layer.slug = reg['slug']
        layer.title = "#{reg['title']} DEFAULT"
        layer.mapcenter_lon = reg['lonlat'][0]
        layer.mapcenter_lat = reg['lonlat'][1]
        layer.created_at = reg['created']
        layer.updated_at = reg['updated']
        layer.published = !reg['hide']
        layer.zoom = reg['zoom']
        layer.public_submission = !reg['moderate']

        layer.save!

        log(map.inspect)
        log(layer.inspect)
      end

      count += 1
    end
    log('====================================')
    log("Number of affected regions #{count}")
    log("Number of failed save operations #{rescue_count}")
    log("Task completed in #{Time.now - start_time} seconds.")
  end

  desc 'migrate users'
  task users: :environment do
    log('Starting task to migrate users => users')

    start_time = Time.now
    users = Mongodb::User.collection.find.to_a

    count = 0
    count_break = 8000
    present = 0
    present_break = 8000
    keys_arr = []

    users.each do |reg|
      break if count > count_break || present > present_break

      log('-----------------------------------')
      log("#{count} / #{present} User: #{reg['email']} - #{reg['uuid']}")
      # log( reg.inspect)
      if User.exists?(['lower(email) = ?', reg['email'].downcase])
        log("NO go: #{reg['email']} - #{reg['uuid']}")
        keys_arr.push reg.keys

        present += 1
        next
      else
        log("Create: #{reg['email']} - #{reg['uuid']}")

        # ActiveRecord::Base.transaction do

        user = User.new

        user.id = reg['uuid']
        user.nickname = reg['nickname']
        user.email = reg['email']
        user.password = reg['crypted_password'][0..126]

        user.password_salt = reg['password_salt']
        user.created_at = reg['created']
        user.updated_at = reg['updated']
        user.last_sign_in_at = reg['last_login']
        user.failed_attempts = reg['failed_logins']
        user.blocked = reg['blocked']
        user.locked_at = DateTime.now if reg['blocked']
        user.confirmed_at = DateTime.now if reg['confirmed']
        user.accept_terms = reg['accept_terms']

        begin
          user.save!
        rescue ActiveModel::ValidationError => e
          puts e.model.errors
        end

        user.encrypted_password = reg['crypted_password']
        user.save!

        # end

      end

      # scopes
      scopes = reg['scopes']
      scopes.each do |role|
        # possible values:  "user", "editor", "admin"
        # we look for:  "region-de698977-48a6-4b40-b566-76c2b2923f95"
        if role['region-']
          uuid = role[7..]
          log("Role with uuid: #{uuid}")
          user.add_role :moderator, Map.find(uuid) if Map.exists?(uuid)
        else
          user.add_role role
        end
      end

      log(user.inspect)

      count += 1
    end
    log('====================================')
    log("Number of affected users #{count}")
    log("Number of already present users #{present}")
    log(keys_arr.uniq.inspect)
    log("Task completed in #{Time.now - start_time} seconds.")
  end

  desc 'migrate location'
  task locations: :environment do
    log('Starting task to migrate locations => places')

    start_time = Time.now
    locations = Mongodb::Location.collection.find.to_a

    count = 0
    locations.each do |loc|
      count += 1
      log('-----------------------------------')
      log("#{count} Place: #{loc['slug']} - #{loc['uuid']}")
      if Place.exists?(loc['uuid'])
        log("#{loc['uuid']} Place exists")
      else
        log("Map: #{loc['region_uuid']}")
        if Map.exists?(loc['region_uuid'])
          map = Map.find(loc['region_uuid'])
          default_layer_id = map.layers.first.id
        else
          map = Map.new
          map.id = loc['region_uuid']
          map.slug = loc['region_uuid']
          map.title = loc['region_uuid']
          map.save!
          layer = Layer.new
          layer.map = map
          layer.slug = loc['region_uuid']
          layer.title = "#{loc['region_uuid']} DEFAULT"
          layer.save!
          default_layer_id = layer.id
        end

        place = Place.new

        place.id = loc['uuid']
        place.slug = loc['slug']
        place.title = loc['title']
        place.text = loc['description']
        place.lon = loc['lonlat'][0]
        place.lat = loc['lonlat'][1]
        place.created_at = loc['created']
        place.updated_at = loc['updated']
        place.owner = loc['owner']
        place.emptySince = loc['emptySince']
        place.buildingType = loc['buildingType']
        place.active = loc['active']
        place.hidden = loc['hidden']
        place.road = loc['street']
        place.city = loc['city']
        place.zip = loc['postcode']

        place.user_id = loc['user_uuid']
        place.map_id = loc['region_uuid']
        place.layer_id = default_layer_id || 'xxxx'
        place.demolished = loc['demolished']
        place.slug_aliases = loc['slug_aliases']

        place.published = !loc['hidden']

        place.save!

      end
    end
    log('====================================')
    log("Number of affected locations #{count}")
    log("Task completed in #{Time.now - start_time} seconds.")
  end

  desc 'migrate comments'
  task comments: :environment do
    log('Starting task to migrate comments => annotations')

    start_time = Time.now
    comments = Mongodb::Comment.collection.find.to_a

    count = 0
    comments.each do |com|
      log('-----------------------------------')
      log("#{count} Comments: #{com['slug']} - #{com['uuid']}")
      if Annotation.exists?(com['uuid'])
        log("#{com['uuid']} Comment exists")
      else
        log("Comment: #{com['subject_uuid']}")

        anno = Annotation.new
        anno.id = com['uuid']
        anno.title = '' # com['title']
        anno.text = com['body']
        anno.created_at = com['created']
        anno.updated_at = com['updated']
        anno.hidden = com['hidden']
        # TODO: add field subject_id
        anno.place_id = com['subject_uuid']
        anno.user_id = com['user_uuid']
        anno.published = !com['hidden']
        begin
          anno.save!
        rescue ActiveRecord::RecordInvalid => e
          puts e.record.errors
        end
      end

      count += 1
    end
    log('====================================')
    log("Number of affected comments #{count}")
    log("Task completed in #{Time.now - start_time} seconds.")
  end

  desc 'migrate images'
  task images: :environment do
    log('Starting task to migrate photos => images')
    unless ENV['IMAGE_PATH'].present?
      log('Please provide the import image path e.g. (IMAGE_PATH=/leerstandsmelder/leerstandsmelder-node-api/assets/photos/)')
      next
    end
    image_path = ENV['IMAGE_PATH']

    log("Image path: #{image_path}")

    start_time = Time.now
    photos = Mongodb::Photo.collection.find.to_a

    count = 0
    non_existend = 0
    rescue_count = 0
    photos.each do |pho|
      log('-----------------------------------')
      log("Photo: #{pho['filename']} - #{pho['uuid']}")
      migrate_file = "#{image_path}#{pho['uuid']}"

      if File.exist?(migrate_file)

        if Image.exists?(pho['uuid'])
          log("#{pho['filename']} Image exists")
        else

          log(pho.inspect)

          img = Image.new

          img.id = pho['uuid']
          img.title = pho['title'] || pho['filename']
          img.created_at = pho['created']
          img.updated_at = pho['updated']
          img.hidden = false
          # # TODO: add field subject_id
          # # img.subject_id = com['subject_uuid']
          img.user_id = pho['user_uuid']
          img.place_id = pho['location_uuid']
          img.preview = false

          img.filename = pho['filename']
          img.extension = pho['extension']
          img.mime_type = pho['mime_type']
          img.filehash = pho['filehash']
          img.size = pho['size']

          unless ENV['DRY_RUN']
            begin
              img.save!

              img.attach(io: File.open("#{image_path}#{pho['uuid']}"), filename: pho['uuid'], content_type: pho['mime_type'])

              img.save!
            rescue StandardError => e
              puts e.inspect
              rescue_count += 1
            end
          end
          count += 1
          log("Exists: #{migrate_file}")
          log("Uploaded for place: #{img.place_id}")
        end
      else
        non_existend += 1
        log("NOT Exists: #{migrate_file}")
      end
    end
    log('====================================')
    log("Number of affected photos #{count}")
    log("Number of not existing photos #{non_existend}")
    log("Number of failed save operations #{rescue_count}")

    log("Task completed in #{Time.now - start_time} seconds.")
  end

  desc 'migrate images'
  task single_image: :environment do
    log('Starting task to migrate photos => images')
    unless ENV['IMAGE_PATH'].present?
      log('Please provide the import image path e.g. (IMAGE_PATH=/leerstandsmelder/leerstandsmelder-node-api/assets/photos/)')
      next
    end
    image_path = ENV['IMAGE_PATH']
    place_uuid = ENV['PLACE_UUID']

    log("Image path: #{image_path}")

    start_time = Time.now
    photos = Mongodb::Photo.collection.find({ "location_uuid": place_uuid }).to_a

    count = 0
    non_existend = 0
    rescue_count = 0
    photos.each do |pho|
      log('-----------------------------------')
      log("Photo: #{pho['filename']} - #{pho['uuid']}")
      migrate_file = "#{image_path}#{pho['uuid']}"

      if File.exist?(migrate_file)

        if Image.exists?(pho['uuid'])
          log("#{pho['filename']} Image exists")
        else

          log(pho.inspect)

          img = Image.new

          img.id = pho['uuid']
          img.title = pho['title'] || pho['filename']
          img.created_at = pho['created']
          img.updated_at = pho['updated']
          img.hidden = false
          # # TODO: add field subject_id
          # # img.subject_id = com['subject_uuid']
          img.user_id = pho['user_uuid']
          img.place_id = pho['location_uuid']
          img.preview = false

          img.filename = pho['filename']
          img.extension = pho['extension']
          img.mime_type = pho['mime_type']
          img.filehash = pho['filehash']
          img.size = pho['size']

          unless ENV['DRY_RUN']
            begin
              img.save!

              img.attach(io: File.open("#{image_path}#{pho['uuid']}"), filename: pho['uuid'], content_type: pho['mime_type'])

              img.save!
            rescue StandardError => e
              puts e.inspect
              rescue_count += 1
            end
          end
          count += 1
          log("Exists: #{migrate_file}")
          log("Uploaded for place: #{img.place_id}")
        end
      else
        non_existend += 1
        log("NOT Exists: #{migrate_file}")
      end
    end
    log('====================================')
    log("Number of affected photos #{count}")
    log("Number of not existing photos #{non_existend}")
    log("Number of failed save operations #{rescue_count}")

    log("Task completed in #{Time.now - start_time} seconds.")
  end
end

def log(msg)
  puts msg
  Rails.logger.info msg
end
