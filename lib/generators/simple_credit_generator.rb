require 'rails/generators'
require 'rails/generators/migration'

class SimpleCreditGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  desc 'Create Simple Credit related tables.'

  self.source_root File.expand_path('../templates', __FILE__)

  def self.next_migration_number(path)
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end

  def generate_migration
    migration_template 'migration.rb',
                       'db/migrate/setup_simple_credit.rb'
  end
end
