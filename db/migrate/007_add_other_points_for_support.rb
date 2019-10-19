class AddOtherPointsForSupport < ActiveRecord::Migration
  def change
    add_column :kpi_settings, :profitability_point_inf, :integer, default: -1
  end
end
