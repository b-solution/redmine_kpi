class AddHourApprovedToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :hour_approved, :integer
    add_column :kpi_settings, :learning_point, :integer, default: 4
    add_column :kpi_settings, :certification_point, :integer, default: 4
    add_column :kpi_settings, :profitability_point, :integer, default: 1
  end
end
