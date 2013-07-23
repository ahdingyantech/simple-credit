require 'active_record'
require 'simple-credit/credit'
require 'simple-credit/credit_history'
require 'simple-credit/model_methods'

module SimpleCredit
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
