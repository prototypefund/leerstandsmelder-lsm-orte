class ChangeGeoColumnTypes < ActiveRecord::Migration[6.1]
  def up
    execute 'ALTER TABLE places ALTER COLUMN lat TYPE FLOAT USING lat::float'
    execute 'ALTER TABLE places ALTER COLUMN lon TYPE FLOAT USING lon::float'
    execute 'ALTER TABLE maps ALTER COLUMN mapcenter_lat TYPE FLOAT USING mapcenter_lat::float'
    execute 'ALTER TABLE maps ALTER COLUMN mapcenter_lon TYPE FLOAT USING mapcenter_lon::float'
    execute 'ALTER TABLE layers ALTER COLUMN mapcenter_lat TYPE FLOAT USING mapcenter_lat::float'
    execute 'ALTER TABLE layers ALTER COLUMN mapcenter_lon TYPE FLOAT USING mapcenter_lon::float'
  end

  def down
    execute 'ALTER TABLE places ALTER COLUMN lat TYPE text USING (lat::text)'
    execute 'ALTER TABLE places ALTER COLUMN lon TYPE text USING (lon::text)'
    execute 'ALTER TABLE maps ALTER COLUMN mapcenter_lat TYPE text USING (mapcenter_lat::text)'
    execute 'ALTER TABLE maps ALTER COLUMN mapcenter_lon TYPE text USING (mapcenter_lon::text)'
    execute 'ALTER TABLE layers ALTER COLUMN mapcenter_lat TYPE text USING (mapcenter_lat::text)'
    execute 'ALTER TABLE layers ALTER COLUMN mapcenter_lon TYPE text USING (mapcenter_lon::text)'
  end
end
