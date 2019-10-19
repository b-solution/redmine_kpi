require_dependency 'issue'

module  RedmineKpi
  module IssuePatch
    def self.included(base)
      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)
      base.class_eval do
       safe_attributes 'hour_approved'
      end
    end

  end
  module ClassMethods


  end

  module InstanceMethods

  end

end