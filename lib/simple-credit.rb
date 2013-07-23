require 'active_record'
require 'simple-credit/credit'

module SimpleCredit
  class CreditHistory < ActiveRecord::Base
    attr_accessible :model, :user, :delta, :scene, :what

    belongs_to :user
    belongs_to :model, polymorphic: true

    default_scope lambda {order(id: :desc)}

    after_save {|hist|
      user   = hist.user
      credit = user.credit

      credit.update_attributes(value: user.credit_histories.sum(:delta))
    }

    def model=(obj)
      self.to_id   = obj.id
      self.to_type = obj.class.to_s
    end

    def model
      self.to_type.constantize.find(self.to_id)
    end
  end

  module ModelMethods
    def self.included(base)
      base.send :extend, ClassMethods
      base.has_many :credit_history,
                    class_name: "SimpleCredit::CreditHistory",
                    as: :model
    end

    module ClassMethods
      def record_credit(options = {})
        options[:on].each do |event|
          send "after_#{event}" do |model|
            user      = options[:user].call(model)
            delta     = options[:delta].call(model)
            what      = "#{event}_#{self.to_s}"
            condition = options[:if].call(model)

            user.credit_histories.create(model: model,
                                         delta: delta,
                                         what: what) if condition
          end
        end
      end
    end
  end

  module UserMethods
    def self.included(base)
      base.has_one  :credit, class_name: "SimpleCredit::Credit"
      base.has_many :credit_histories, class_name: "SimpleCredit::CreditHistory"
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def add_credit(delta, scene, model)
        what = "create_#{model.class.to_s}"
        credit_histories.create(delta: delta,
                                scene: scene,
                                model: model,
                                what:  what)
      end

      def credit_value
        credit.value
      end

      def credit_relation
        Credit.where(user_id: self.id)
      end

      def credit
        return credit_relation.create if credit_relation.blank?
        credit_relation.first
      end
    end
  end
end
