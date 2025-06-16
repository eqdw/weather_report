class CreateForecasts < ActiveRecord::Migration[8.0]
  def change
    create_table :forecasts do |t|
      t.string :data
      t.datetime :valid_until
      t.string :zip

      t.timestamps
    end
  end
end
