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
            scene     = options[:scene]
            user      = options[:user].call(model)
            delta     = options[:delta].call(model)
            what      = "#{event}_#{self.class.to_s}"
            condition = options[:if] ? options[:if].call(model) : true

            return user.cancel_add_credit(scene, model) if delta == :cancel
            user.credit_histories.create(model: model,
                                         scene: scene,
                                         delta: delta,
                                         what: what) if condition
          end
        end
      end
    end
  end
end
