class CreateKpis < ActiveRecord::Migration
  def change
    create_table :kpis do |t|

      t.integer :issue_id

      t.integer :user_id

      t.integer :difference

      t.integer :points


    end

    add_index :kpis, :issue_id

    add_index :kpis, :user_id

  end
end
