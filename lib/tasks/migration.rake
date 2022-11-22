# frozen_string_literal: true

namespace :migration do
  desc 'migrate regions'
  task regions: :environment do
    def log(msg)
      puts msg
      Rails.logger.info msg
    end

    log('Starting task to migrate regions => maps')

    start_time = Time.now
    regions = Mongodb::Region.collection.find.to_a

    count = 0
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

        map.save!

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
    log("Task completed in #{Time.now - start_time} seconds.")
  end

  desc 'migrate users'
  task users: :environment do
    def log(msg)
      puts msg
      Rails.logger.info msg
    end

    log('Starting task to migrate users => users')

    start_time = Time.now
    users = Mongodb::User.collection.find.to_a

    count = 0
    count_break = 3000
    present = 0
    present_break = 1000
    users.each do |reg|
      break if count > count_break || present > present_break

      log('-----------------------------------')
      log("User: #{reg['email']} - #{reg['uuid']}")
      # log( reg.inspect)
      if User.exists?(['lower(email) = ?', reg['email'].downcase])
        log("NO go: #{reg['email']} - #{reg['uuid']}")
        log("NO go: #{reg.inspect}")
        present += 1
        next
      else
        log("Lets go: #{reg['email']} - #{reg['uuid']}")

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
    log("Task completed in #{Time.now - start_time} seconds.")
  end

  desc 'migrate location'
  task locations: :environment do
    def log(msg)
      puts msg
      Rails.logger.info msg
    end

    log('Starting task to migrate locations => places')

    start_time = Time.now
    locations = Mongodb::Location.collection.find.to_a

    count = 0
    locations.each do |loc|
      puts loc['slug']
      count += 1
    end
    log("Number of affected locations #{count}")
    log("Task completed in #{Time.now - start_time} seconds.")
  end
end
