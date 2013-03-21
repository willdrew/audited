require 'mongo_mapper'
require 'audited/auditor'
require 'audited/adapters/mongo_mapper/audited_changes'
require 'audited/adapters/mongo_mapper/audit'

module Audited::Auditor::ClassMethods
  def default_ignored_attributes
    ['id', '_id']
  end
end

::MongoMapper::Document.plugin Audited::Auditor

Audited.audit_class = Audited::Adapters::MongoMapper::Audit

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
