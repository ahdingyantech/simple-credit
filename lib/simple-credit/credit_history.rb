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
end
