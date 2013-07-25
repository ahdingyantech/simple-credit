module SimpleCredit
  class CreditHistory < ActiveRecord::Base
    attr_accessible :model, :user, :delta, :scene, :what

    belongs_to :user
    belongs_to :model, polymorphic: true

    default_scope lambda {order(id: :desc)}

    after_save {|hist|
      value      = hist.sum >= 0 ? hist.sum : 0
      is_highest = value > hist.user.highest_credit

      hist.user.credit.update_attributes(value: value)
      hist.user.credit.update_attributes(highest_value: value) if is_highest
    }

    def sum
      user.credit_histories.sum(:delta)
    end

    def model=(obj)
      self.to_id   = obj.id
      self.to_type = obj.class.to_s
    end

    def model
      self.to_type.constantize.find(self.to_id)
    end
  end
end
