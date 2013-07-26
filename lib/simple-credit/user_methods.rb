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

      def cancel_add_credit(scene, model)
        last = credit_histories
          .where(scene: scene, to_id: model.id)
          .order(:id => :desc)
          .first
        refund = - last.real
        self.credit_histories.create(scene:     scene,
                                     model:     model,
                                     delta:     refund,
                                     what:      :cancel,
                                     canceled_id: last.id)
      end

      def highest_credit
        self.credit.highest_value
      end

      def max_deduction
        - credit_value
      end

      def zero_credit?
        hist.user.credit_value == 0
      end

      def credit_value
        credit.value
      end

      def credit
        return credit_relation.create if credit_relation.blank?
        credit_relation.first
      end

      private

      def credit_relation
        Credit.where(user_id: self.id)
      end
    end
  end
end
