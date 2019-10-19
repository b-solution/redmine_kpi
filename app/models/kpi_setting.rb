class KpiSetting < ActiveRecord::Base
  validates_presence_of :effective_date,  :h_task_before_deadline,  :h_task_on_deadline,
                        :h_task_after_deadline,  :n_task_before_deadline,  :n_task_on_deadline,
                        :n_task_after_deadline,  :l_task_before_deadline,  :l_task_on_deadline,
                        :l_task_after_deadline,
                        :low_utilization, :high_utilization
  validates_uniqueness_of :effective_date

  def for_high_utilization
    {
        before: h_task_before_deadline,
        on: h_task_on_deadline,
        after: h_task_after_deadline
    }
  end

  def for_normal_utilization
    {
        before: n_task_before_deadline,
        on: n_task_on_deadline,
        after: n_task_after_deadline
    }
  end

  def for_low_utilization
    {
        before: l_task_before_deadline,
        on: l_task_on_deadline,
        after: l_task_after_deadline
    }
  end

  def self.default
    new(:h_task_before_deadline=> 6,  :h_task_on_deadline=> 4,  :h_task_after_deadline=> 0,
        :n_task_before_deadline=> 5,  :n_task_on_deadline=> 3,  :n_task_after_deadline=> 0,
        :l_task_before_deadline=> 4,  :l_task_on_deadline=> 2,  :l_task_after_deadline=> 0,
        :low_utilization=> 40,        :normal_utilization=> 60, :high_utilization=> 60,
        :time_record_point=> 2,
        profitability_point: 1,
        learning_point: 4, certification_point: 3,
        reopened_ticket_point: 2, closed_ticket_point: 2,
        one_day_started_ticket_point: 4,  two_day_started_ticket_point: 2, three_day_started_ticket_point: 1,
        presales_point: 6)
  end


end
