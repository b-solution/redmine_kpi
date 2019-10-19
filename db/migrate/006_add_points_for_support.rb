class AddPointsForSupport < ActiveRecord::Migration
  def change
    add_column :kpi_settings, :reopened_ticket_point, :integer, default: 2
    add_column :kpi_settings, :closed_ticket_point, :integer, default: 2
    add_column :kpi_settings, :one_day_started_ticket_point, :integer, default: 4
    add_column :kpi_settings, :two_day_started_ticket_point, :integer, default: 2
    add_column :kpi_settings, :three_day_started_ticket_point, :integer, default: 1
  end
end
