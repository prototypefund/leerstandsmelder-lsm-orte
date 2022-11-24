# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_11_23_153719) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "annotations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.text "text"
    t.uuid "place_id"
    t.uuid "person_id"
    t.boolean "published", default: false
    t.integer "sorting"
    t.text "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_id"
    t.string "to_user_id"
    t.boolean "hidden", default: false
    t.string "legacy_id"
  end

  create_table "build_logs", force: :cascade do |t|
    t.uuid "map_id"
    t.uuid "layer_id"
    t.string "output"
    t.string "size"
    t.string "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["layer_id"], name: "index_build_logs_on_layer_id"
    t.index ["map_id"], name: "index_build_logs_on_map_id"
  end

  create_table "groups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.text "message"
  end

  create_table "icons", force: :cascade do |t|
    t.string "title"
    t.bigint "iconset_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["iconset_id"], name: "index_icons_on_iconset_id"
  end

  create_table "iconsets", force: :cascade do |t|
    t.string "title"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "icon_anchor"
    t.string "icon_size"
    t.string "popup_anchor"
    t.string "class_name"
  end

  create_table "images", force: :cascade do |t|
    t.string "title"
    t.string "licence"
    t.text "source"
    t.string "creator"
    t.uuid "place_id"
    t.string "alt"
    t.string "caption"
    t.integer "sorting"
    t.boolean "preview"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "itype", default: "image"
    t.index ["place_id"], name: "index_images_on_place_id"
  end

  create_table "layers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.string "subtitle"
    t.boolean "published"
    t.uuid "map_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
    t.text "text"
    t.boolean "public_submission"
    t.string "slug"
    t.text "credits"
    t.string "mapcenter_lat"
    t.string "mapcenter_lon"
    t.integer "zoom", default: 12
    t.text "teaser"
    t.text "style"
    t.text "basemap_url"
    t.text "basemap_attribution"
    t.string "tooltip_display_mode", default: "none"
    t.string "places_sort_order"
    t.string "background_color", default: ""
    t.boolean "exif_remove", default: true
    t.boolean "rasterize_images", default: false
    t.integer "relations_bending", default: 1
    t.string "relations_coloring", default: "colored"
    t.boolean "use_mapcenter_from_parent_map", default: true
    t.text "image_alt"
    t.string "image_licence"
    t.text "image_source"
    t.string "image_creator"
    t.string "image_caption"
    t.boolean "use_background_from_parent_map", default: true
    t.index ["map_id"], name: "index_layers_on_map_id"
    t.index ["slug"], name: "index_layers_on_slug", unique: true
  end

  create_table "maps", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.string "subtitle"
    t.boolean "published"
    t.uuid "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "script"
    t.string "northeast_corner"
    t.string "southwest_corner"
    t.text "text"
    t.integer "iconset_id"
    t.string "basemap_url"
    t.string "basemap_attribution"
    t.string "slug"
    t.string "popup_display_mode", default: "click"
    t.boolean "show_annotations_on_map", default: false
    t.text "credits"
    t.text "teaser"
    t.text "style"
    t.string "color"
    t.string "mapcenter_lat"
    t.string "mapcenter_lon"
    t.integer "zoom", default: 12
    t.string "tooltip_display_mode", default: "none"
    t.string "places_sort_order"
    t.string "background_color", default: "#454545"
    t.string "preview_url"
    t.boolean "enable_map_to_go", default: false
    t.boolean "enable_privacy_features", default: true
    t.index ["group_id"], name: "index_maps_on_group_id"
    t.index ["slug"], name: "index_maps_on_slug", unique: true
  end

  create_table "mobility_string_translations", force: :cascade do |t|
    t.string "locale", null: false
    t.string "key", null: false
    t.string "value"
    t.string "translatable_type"
    t.bigint "translatable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["translatable_id", "translatable_type", "key"], name: "index_mobility_string_translate_translatable_attribute"
    t.index ["translatable_id", "translatable_type", "locale", "key"], name: "index_mobility_string_translations_on_keys", unique: true
    t.index ["translatable_type", "key", "value", "locale"], name: "index_mobility_string_translate_query_keys"
  end

  create_table "mobility_text_translations", force: :cascade do |t|
    t.string "locale", null: false
    t.string "key", null: false
    t.text "value"
    t.string "translatable_type"
    t.bigint "translatable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["translatable_id", "translatable_type", "key"], name: "index_mobility_text_translations_on_translatable_attribute"
    t.index ["translatable_id", "translatable_type", "locale", "key"], name: "index_mobility_text_translations_on_keys", unique: true
  end

  create_table "people", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.text "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "map_id"
    t.index ["map_id"], name: "index_people_on_map_id"
  end

  create_table "places", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.text "teaser"
    t.text "text"
    t.string "link"
    t.datetime "startdate"
    t.datetime "enddate"
    t.string "lat"
    t.string "lon"
    t.string "location"
    t.string "address"
    t.string "zip"
    t.string "city"
    t.string "country"
    t.boolean "published"
    t.uuid "layer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "imagelink"
    t.integer "icon_id"
    t.boolean "featured"
    t.boolean "shy", default: false
    t.boolean "sensitive", default: false
    t.integer "sensitive_radius", default: 100
    t.string "road"
    t.string "house_number"
    t.string "borough"
    t.string "suburb"
    t.string "country_code"
    t.uuid "user_id"
    t.boolean "rumor", default: false
    t.string "slug", default: ""
    t.string "owner", default: ""
    t.string "emptySince", default: ""
    t.string "buildingType", default: ""
    t.uuid "map_id"
    t.boolean "active", default: false
    t.boolean "hidden", default: false
    t.boolean "demolished", default: false
    t.string "slug_aliases", default: [], array: true
    t.index ["layer_id"], name: "index_places_on_layer_id"
    t.index ["map_id"], name: "index_places_on_map_id"
    t.index ["user_id"], name: "index_places_on_user_id"
  end

  create_table "relations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "relation_from_id"
    t.uuid "relation_to_id"
    t.string "rtype"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.uuid "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "submission_configs", force: :cascade do |t|
    t.string "title_intro"
    t.string "subtitle_intro"
    t.text "intro"
    t.string "title_outro"
    t.text "outro"
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean "use_city_only"
    t.uuid "layer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "locales"
    t.index ["layer_id"], name: "index_submission_configs_on_layer_id"
  end

  create_table "submissions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.boolean "rights"
    t.boolean "privacy"
    t.string "locale"
    t.uuid "place_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.index ["place_id"], name: "index_submissions_on_place_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.uuid "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "taggings_count", default: 0
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "role", default: "user"
    t.uuid "group_id"
    t.datetime "created_at", default: "2022-11-23 10:34:18", null: false
    t.datetime "updated_at", default: "2022-11-23 10:34:18", null: false
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.text "tokens"
    t.boolean "allow_password_change", default: false
    t.string "nickname"
    t.boolean "confirmed", default: false
    t.boolean "blocked", default: false
    t.boolean "message_me", default: false
    t.boolean "notify", default: false
    t.boolean "share_email", default: false
    t.boolean "accept_terms", default: false
    t.string "legacy_id"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "password_salt"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["group_id"], name: "index_users_on_group_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
  end

  create_table "videos", force: :cascade do |t|
    t.string "title"
    t.string "licence"
    t.text "source"
    t.string "creator"
    t.uuid "place_id"
    t.string "alt"
    t.string "caption"
    t.integer "sorting"
    t.boolean "preview"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id"], name: "index_videos_on_place_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "annotations", "people"
  add_foreign_key "annotations", "places"
  add_foreign_key "build_logs", "layers"
  add_foreign_key "build_logs", "maps"
  add_foreign_key "icons", "iconsets"
  add_foreign_key "images", "places"
  add_foreign_key "layers", "maps"
  add_foreign_key "maps", "groups"
  add_foreign_key "people", "maps"
  add_foreign_key "places", "layers"
  add_foreign_key "places", "maps"
  add_foreign_key "submission_configs", "layers"
  add_foreign_key "submissions", "places"
  add_foreign_key "taggings", "tags"
  add_foreign_key "users", "groups"
  add_foreign_key "videos", "places"
end
