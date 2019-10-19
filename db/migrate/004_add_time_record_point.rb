class AddTimeRecordPoint < ActiveRecord::Migration
  def change
    add_column :kpi_settings, :time_record_point, :integer, default: 2
    add_column :kpi_settings, :presales_point, :integer, default: 2
  end
end
