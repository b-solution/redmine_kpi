class CreateOriginIssueIdToTimeEntry < ActiveRecord::Migration
  def change
    add_column :time_entries, :origin_issue_id, :integer
  end
end
