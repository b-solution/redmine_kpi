class CreateKpiSettings < ActiveRecord::Migration
  def change
    create_table :kpi_settings do |t|
      t.date :effective_date
      t.integer :h_task_before_deadline
      t.integer :h_task_on_deadline
      t.integer :h_task_after_deadline
      t.integer :n_task_before_deadline
      t.integer :n_task_on_deadline
      t.integer :n_task_after_deadline
      t.integer :l_task_before_deadline
      t.integer :l_task_on_deadline
      t.integer :l_task_after_deadline

      t.integer :high_utilization
      t.integer :normal_utilization
      t.integer :low_utilization

      t.timestamps null: false
    end
  end
end
