require_dependency 'time_entry'

module  RedmineKpi
  module TimeEntryPatch
    def self.included(base)
      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)
      base.class_eval do
       safe_attributes 'origin_issue_id'
        before_save do
          approval_custom_field = Setting.plugin_redmine_kpi['approval_custom_field']
          if approval_custom_field.present? && (cf = TimeEntryCustomField.find_by(approval_custom_field)) && ( custom_field_value = self.visible_custom_field_values.detect{|cfv| cfv.custom_field_id == cf.id} )
            custom_field_value.value = false unless User.current.allowed_to_globally?(:approve_time_entry, {})
          end
        end
      end
    end

  end
  module ClassMethods


  end

  module InstanceMethods

  end

end