require 'active_record'
require 'audited/auditor'
require 'audited/adapters/active_record/audit'

module Audited::Auditor::ClassMethods
  def default_ignored_attributes
    [self.primary_key, inheritance_column]
  end
end

::ActiveRecord::Base.send :include, Audited::Auditor

Audited.audit_class = Audited::Adapters::ActiveRecord::Audit

module Audited
  class AuditedRailtie < ::Rails::Railtie
    config.after_initialize do
      if defined? ActiveModel::Observer
        require 'audited/sweeper'
      else
        if Rails::VERSION::MAJOR >= 4
          raise "Please install gem 'rails-observers', '~> 0.1.0'"
        else
          raise "'ActiveModel::Observer' not defined!"
        end
      end
    end
  end
end
