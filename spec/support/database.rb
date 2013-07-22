require 'generators/templates/migration'

ActiveRecord::Base.logger = ActiveSupport::BufferedLogger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Schema.define do
  create_table :users unless table_exists?(:users)

  create_table :dummy_models, :force => true do |t|
    t.integer :user_id
    t.boolean :dummy, :default => false
    t.integer :bla
    t.timestamps
  end unless table_exists?(:dummy_models)
end

SetupSimpleCredit.migrate(:up)

class DummyModel < ActiveRecord::Base
  attr_accessible :nonsense
  include SimpleCredit::ModelMethods

  belongs_to :user

  record_credit(:scene => :credit_for_being_dummy,
                :on    => [:create, :update, :destroy],
                :user  => lambda {|model| model.user},
                :delta => lambda {|model| 2},
                :if    => lambda {|model| model.dummy})
end

class User < ActiveRecord::Base
  include SimpleCredit::UserMethods

  has_many :dummy_models
end
