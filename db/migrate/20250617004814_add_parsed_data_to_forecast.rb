class AddParsedDataToForecast < ActiveRecord::Migration[8.0]
  def change
    change_table :forecasts do |t|
      t.remove :data

      t.datetime :valid_at
      t.string :temp
      t.string :temp_min
      t.string :temp_max
      t.string :humidity
      t.string :wind_direction
      t.string :wind_speed
    end
  end
end
