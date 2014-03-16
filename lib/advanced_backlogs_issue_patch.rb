require_dependency 'issue'

module AdvancedBacklogs
  module IssuePatch
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable

        before_save :calc_done_ratio_before_save
      end
    end

    module ClassMethods
    end

    module InstanceMethods
      def calc_done_ratio_before_save
        self.calc_done_ratio

        # scrub done ratio from the journal by copying the new value to the old
        @attributes_before_change['done_ratio'] = self.done_ratio if @attributes_before_change
        return true
      end

      def calc_done_ratio
        Rails.logger.debug "\n\nSTART CALC DONE RATIO\n\n"
        # Don't calc done ratio for new issue or issue with subtasks
        if self.id and self.leaves.count == 0
          begin
            total_hours = self.spent_hours + self.remaining_hours
            if total_hours > 0
              self.done_ratio = self.spent_hours / total_hours * 100
            else
              self.done_ratio = 100
            end
            Rails.logger.debug "\n\nEND CALC DONE RATIO #{self.done_ratio}\n\n"
          rescue ArgumentError, TypeError
          end
        end
      end
    end
  end
end

Issue.send(:include, AdvancedBacklogs::IssuePatch) unless Issue.included_modules.include? AdvancedBacklogs::IssuePatch
