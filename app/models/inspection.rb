class Inspection < ApplicationRecord

  include DefaultSortingConcern
  include FulltextConcern
  include CaptionConcern

  cattr_accessor :fulltext_fields do
    []
  end

  def self.permitted_attributes
    return :street_address,:visible,:chimney_cap_spark_arrestor,:chimney_height,:crown_wash,:flashing,:flue_liner_condition,:flue_liner_proper_size,:proper_flue_material_for_appliance,:moisture_resistance,:smoke_chamber_smooth_parged,:flue_tile_sealed_smoke_chamber,:brick_and_mortar,:smoke_shelf,:connector_to_flue,:inspector_name
  end
end
