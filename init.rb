Redmine::Plugin.register :redmine_kpi do
  name 'Redmine Kpi plugin'
  author 'Bilel KEDIDI'
  description 'This is a plugin for Redmine'
  version '1.0.1'

  menu :top_menu, :KPIS, {:controller => 'kpi', :action => 'index' },
       :caption => 'My KPIs', html: {class: 'icon icon-stats'},  :if => Proc.new {
        User.current.allowed_to_globally?(:view_own, {}) or
            User.current.allowed_to_globally?(:view_others, {})
      }
  menu :admin_menu, :KPIS, {:controller => 'kpi_settings', :action => 'index' },
       :caption => 'KPIs', html: {class: 'icon icon-list'}

  project_module :KPIs do
    permission :view_own, kpi: [:index, :search]
    permission :view_others, kpi: [:index, :search]
    permission :manage_KPIs, {}
    permission :approve_time_entry, {}
  end

  class RedmineKpiHook < Redmine::Hook::ViewListener
    render_on  :view_timelog_edit_form_bottom, :partial=> 'timelog/show_issue_origin_in_time_entry'
    render_on  :view_issues_edit_notes_bottom, :partial=> 'timelog/show_issue_origin'
    render_on  :timelog_form_spent_on_bottom, :partial=> 'timelog/show_issue_origin_in_time_entry'
    render_on  :view_issues_show_details_bottom, :partial=> 'issues/show_approved_hour'
    render_on  :view_issues_form_details_after_time_entries, :partial=> 'issues/edit_approved_hour'

  end
  settings :default => {
      'issues_status'  => [],
      'deadline_custom_field'     => '',
      'presales_status'     => '',
      'presales_project'     => '',
      'issue_for_time_recording'=> "1111",
      'violation_time_record'=> '3',
  }, :partial => 'kpi/settings/setting'

end
Rails.application.config.to_prepare do
  TimeEntry.send(:include, RedmineKpi::TimeEntryPatch)
  Issue.send(:include, RedmineKpi::IssuePatch)
end
