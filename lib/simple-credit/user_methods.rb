module SimpleCredit
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
