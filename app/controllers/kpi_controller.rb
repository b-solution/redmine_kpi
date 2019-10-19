class KpiController < ApplicationController

  before_action :require_login
  before_action :authorize
  before_action :get_dates#, except: [:promptness, :profitability, :support]
  # before_action :get_dates_with_days, only: [:promptness, :profitability, :support]

  def index

    @billable_projects = Project.where(id: Setting.plugin_redmine_kpi['billable_projects']).map(&:self_and_descendants).flatten.compact
    issue_status = Setting.plugin_redmine_kpi['issues_status'].map(&:to_i)
    @data = Issue.joins(:time_entries).includes(:project).references(:project).
        where("time_entries.spent_on = (SELECT MAX(time_entries.spent_on) FROM time_entries WHERE time_entries.issue_id = issues.id and time_entries.user_id = #{@user.id})").
        where('time_entries.spent_on BETWEEN ? and ?', @date_from, @date_to).
        where('time_entries.user_id = ?', @user.id ).
        where(issues: {project_id: @billable_projects.map(&:id)  }).
        where(status_id: issue_status)
  end

  def promptness

    @billable_projects = Project.where(id: Setting.plugin_redmine_kpi['billable_projects']).map(&:self_and_descendants).flatten.compact

    issue_status = Setting.plugin_redmine_kpi['issues_status'].map(&:to_i)


    if @user && @date_from && @date_to
      @data = Issue.joins(:time_entries).includes(:project).references(:project).
          where("time_entries.spent_on = (SELECT MAX(time_entries.spent_on) FROM time_entries WHERE time_entries.issue_id = issues.id and time_entries.user_id = #{@user.id})").
          where('time_entries.spent_on BETWEEN ? and ?', @date_from, @date_to).
          where('time_entries.user_id = ?', @user.id ).
          where(issues: {project_id: @billable_projects.map(&:id)  }).
          where(status_id: issue_status)
    end
  end

  def profitability

    @billable_projects = Project.where(id: Setting.plugin_redmine_kpi['billable_projects']).map(&:self_and_descendants).flatten.compact
    issue_status = Setting.plugin_redmine_kpi['issues_status'].map(&:to_i)
    if @user && @date_from && @date_to
      @data = Issue.joins(:time_entries).includes(:project).references(:project).
          where("time_entries.spent_on = (SELECT MAX(time_entries.spent_on) FROM time_entries WHERE time_entries.issue_id = issues.id and time_entries.user_id = #{@user.id})").
          where('time_entries.spent_on BETWEEN ? and ?', @date_from, @date_to).
          where('time_entries.user_id = ?', @user.id ).
          where(issues: {project_id: @billable_projects.map(&:id)  }).
          where(status_id: issue_status)
    end
  end

  def support
    @support_projects = Project.where(id: Setting.plugin_redmine_kpi['support_projects']).map(&:self_and_descendants).flatten.compact
  end

  def presales

  end

  def time_record

    if request.get?
      if Date.today.month > 6
        params[:date_from] =   (Date.today.beginning_of_year + 6.months).beginning_of_month.strftime('%m %Y')
        params[:date_to] =  (Date.today.end_of_year).strftime('%m %Y')
      else
        params[:date_from] =   (Date.today.beginning_of_year).strftime('%m %Y')
        params[:date_to] =   (Date.today.beginning_of_year + 5.months).beginning_of_month.strftime('%m %Y')
      end
    end
  end

  def learning

  end

  private

  def get_dates_with_days
    params[:use_select] ||=  cookies[:use_select]
    params[:times_choice] ||=  cookies[:times_choice]
    params[:date_to] ||=  cookies[:date_to]
    params[:date_from] ||=  cookies[:date_from]
    params[:user_id] ||= cookies[:user_id]

    if request.post?
      if params[:use_select] == 'true'
        case params[:times_choice]
          when '1'
            if Date.today.month > 6
              @date_from =   (Date.today.beginning_of_year + 6.months).beginning_of_month
              @date_to =  (Date.today.end_of_year)
            else
              @date_from =   (Date.today.beginning_of_year)
              @date_to =   (Date.today.beginning_of_year + 5.months).beginning_of_month
            end

          when '11'
            @date_from =   Date.today.beginning_of_year
            @date_to =  (Date.today.beginning_of_year + 5.months).end_of_month

          when '2'
            @date_from =  ( Date.today.beginning_of_year - 1.year)
            @date_to = (Date.today.beginning_of_year - 1.year + 5.months).end_of_month

          when '22'
            @date_from =  (Date.today.beginning_of_year - 1.year + 6.months + 1.day)
            @date_to =  (Date.today.beginning_of_year - 1.day)

          when '3'
            @date_from =  (Date.today.beginning_of_month  - 3.months)
            @date_to =  (Date.today.beginning_of_month - 1.months).end_of_month

          when "4"
            @date_from =  (Date.today.beginning_of_month  - 3.months)
            @date_to =  (Date.today.beginning_of_month - 1.months).end_of_month

          when "5"
            @date_from =  (Date.today.beginning_of_month)
            @date_to =  (Date.today).end_of_month
          else
            @date_to = Date.parse(params[:date_to]) rescue nil
            @date_from = Date.parse(params[:date_from]) rescue nil
        end
      else
        @date_to = Date.parse(params[:date_to]) rescue nil
        @date_from = Date.parse(params[:date_from]) rescue nil
      end
      cookies[:use_select] =  params[:use_select]
      cookies[:times_choice] =  params[:times_choice]
      cookies[:date_to] =  params[:date_to]
      cookies[:date_from] =  params[:date_from]

    else
      params[:times_choice] ||= 1
      params[:date_from] ||= Date.today.beginning_of_year
      params[:date_to] ||= (Date.today.beginning_of_year + 5.months).end_of_month
      @date_from ||= Date.today.beginning_of_year
      @date_to ||= (Date.today.beginning_of_year + 5.months).end_of_month
    end

    @user = if User.current.allowed_to_globally?(:view_others, {})
              User.find( params[:user_id]) rescue User.current
            else
              User.current
            end
    cookies[:user_id] = @user.try(:id)
  end

  def get_dates
    params[:use_select] ||=  cookies[:use_select]
    params[:times_choice] ||=  cookies[:times_choice]
    params[:date_to] ||=  cookies[:date_to_days]
    params[:date_from] ||=  cookies[:date_from_days]
    params[:user_id] ||= cookies[:user_id]
    if request.get?
      if Date.today.month > 6
        params[:date_from] ||=   (Date.today.beginning_of_year + 6.months).beginning_of_month.strftime('%m %Y')
        params[:date_to] ||=  (Date.today.end_of_year).strftime('%m %Y')
      else
        params[:date_from] ||=   (Date.today.beginning_of_year).strftime('%m %Y')
        params[:date_to] ||=   (Date.today.beginning_of_year + 5.months).beginning_of_month.strftime('%m %Y')
      end

    end

    if (params[:use_select]) == 'true'
      case params[:times_choice]
        when '1'
          if Date.today.month > 6
            @date_from =   (Date.today.beginning_of_year + 6.months).beginning_of_month
            @date_to =  (Date.today.end_of_year)
          else
            @date_from =   (Date.today.beginning_of_year)
            @date_to =   (Date.today.beginning_of_year + 5.months).beginning_of_month
          end

        when '11'
          @date_from =   Date.today.beginning_of_year
          @date_to =  (Date.today.beginning_of_year + 5.months).end_of_month

        when '2'
          @date_from =  ( Date.today.beginning_of_year - 1.year)
          @date_to = (Date.today.beginning_of_year - 1.year + 5.months).end_of_month

        when '22'
          @date_from =  (Date.today.beginning_of_year - 1.year + 6.months + 1.day)
          @date_to =  (Date.today.beginning_of_year - 1.day)

        when '3'
          @date_from =  (Date.today.beginning_of_month  - 3.months)
          @date_to =  (Date.today.beginning_of_month - 1.months).end_of_month

        when "4"
          @date_from =  (Date.today.beginning_of_month  - 3.months)
          @date_to =  (Date.today.beginning_of_month - 1.months).end_of_month

        when "5"
          @date_from =  (Date.today.beginning_of_month)
          @date_to =  (Date.today).end_of_month
        else
          @date_to = Date.parse( "01 #{(params[:date_to])}".gsub(' ', '/')).end_of_month rescue nil
          @date_from = Date.parse("01 #{(params[:date_from])}".gsub(' ', '/')) rescue nil
      end
    else
      @date_to = Date.parse( "01 #{(params[:date_to])}".gsub(' ', '/')).end_of_month rescue nil
      @date_from = Date.parse("01 #{(params[:date_from])}".gsub(' ', '/')) rescue nil
    end

    cookies[:use_select] =  params[:use_select]
    cookies[:times_choice] =  params[:times_choice]
    cookies[:date_to_days] =  params[:date_to]
    cookies[:date_from_days] =  params[:date_from]


    @user = if User.current.allowed_to_globally?(:view_others, {})
              User.find( params[:user_id]) rescue User.current
            else
              User.current
            end
    cookies[:user_id] = @user.try(:id)
  end

  def authorize
    User.current.allowed_to_globally?(:view_others, {}) or   User.current.allowed_to_globally?(:view_own, {})
  end

end
