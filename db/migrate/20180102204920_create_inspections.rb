class CreateInspections < ActiveRecord::Migration[5.1]
  def change
    create_table :inspections do |t|
      t.string :street_address
      t.boolean :visible
      t.string :chimney_cap_spark_arrestor
      t.string :chimney_height
      t.string :crown_wash
      t.string :flashing
      t.string :flue_liner_condition
      t.string :flue_liner_proper_size
      t.string :proper_flue_material_for_appliance
      t.string :moisture_resistance
      t.string :smoke_chamber_smooth_parged
      t.string :flue_tile_sealed_smoke_chamber
      t.string :brick_and_mortar
      t.string :smoke_shelf
      t.string :connector_to_flue
      t.string :inspector_name

      t.timestamps
    end
  end
end
