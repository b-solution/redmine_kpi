class Kpi < ActiveRecord::Base
  validates_presence_of :points, :issue_id, :user_id
end
