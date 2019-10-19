module KpiHelper
  def draw_color(duration, diff)
    if diff.to_i > 0
      'red'
    elsif diff.to_i < 0
      'green'
    else
      'blue'
    end
  end

  def draw_utilization_color(date_from, utilization)
    @kpi_setting  = kpi_finder(date_from)
    if utilization >= @kpi_setting.high_utilization.to_i
      'green'
    elsif utilization <= @kpi_setting.low_utilization.to_i
      'red'
    else
      'blue'
    end
  end

  def draw_profitability_color(date_from, utilization)
    return 'orange' if utilization == 200
    @kpi_setting  = kpi_finder(date_from)
    if utilization > 25
      'green'
    elsif utilization < 25
      'red'
    else
      'orange'
    end
  end

  def draw_profitability_point(date_from, utilization)
    return 0 if utilization == 200
    @kpi_setting  = kpi_finder(date_from)
    if utilization > 25
      @kpi_setting.profitability_point
    elsif utilization < 25
      @kpi_setting.profitability_point_inf
    else
      0
    end
  end

  def get_target(date_from, utilization)
    @kpi_setting  = kpi_finder(date_from)
    if utilization >= @kpi_setting.high_utilization.to_i
      @kpi_setting.for_high_utilization[:before]
    elsif utilization <= @kpi_setting.low_utilization.to_i
      @kpi_setting.for_low_utilization[:before]
    else
      @kpi_setting.for_normal_utilization[:before]
    end
  end

  def kpi_finder(date_from)
    @kpi_setting ||= (KpiSetting.where('effective_date <= :date', date: date_from).order('effective_date DESC').first || KpiSetting.default)
  end

  def get_promptness_color  points, max
    if points.to_i.zero?
      'red'
    elsif points.to_i < max/2
      'orange'
    else
      'green'
    end
  end

 def get_support_color  points, max
    if points.to_i.zero?
      'red'
    elsif points.to_i < max/2
      'orange'
    else
      'green'
    end
  end

  def calculate_points(diff, date_from, utilization)
    @kpi_setting  = kpi_finder(date_from)
    points_rate  = if utilization > @kpi_setting.high_utilization.to_i
                     @kpi_setting.for_high_utilization
                   elsif utilization < @kpi_setting.low_utilization.to_i
                     @kpi_setting.for_low_utilization
                   else
                     @kpi_setting.for_normal_utilization
                   end
    if diff > 0
      points_rate[:after]
    elsif diff < 0
      points_rate[:before]
    else
      points_rate[:on]
    end
  end

  def lowest_point(date_from)
    @kpi_setting  = kpi_finder(date_from)
    points_rate  = @kpi_setting.for_low_utilization
    points_rate[:after]
  end
end
