# -*- coding: utf-8 -*-
module SimpleCredit
  class CreditHistory < ActiveRecord::Base
    attr_accessible :model, :user, :delta, :scene, :what, :canceled_id

    belongs_to :user
    belongs_to :model, polymorphic: true

    default_scope lambda {order(id: :desc)}

    before_save do |hist|
      if !hist.what.to_s.include?("destroy")
        prev = hist.prev(hist.scene, hist.model)

        if prev && !hist.canceled_id
          if hist.delta > 0 && prev.delta < 0
            hist.delta = hist.delta - prev.delta
          elsif hist.delta < 0 && prev.delta > 0
            hist.delta = hist.delta - prev.delta
          end
        end if prev
      end

      hist.real   = hist.calculate_real
      hist.before = hist.user.credit_value
      hist.after  = hist.user.credit_value + hist.real
    end

    after_save do |hist|
      value      = hist.user.credit_value + hist.real
      is_highest = value > hist.user.highest_credit

      hist.user.credit.update_attributes(value: value)
      hist.user.credit.update_attributes(highest_value: value) if is_highest
    end

    def prev(scene, model)
      user.credit_histories
        .where(scene: scene, to_id: model.id)
        .order(:id => :desc)
        .first
    end

    def calculate_real
       delta < user.max_deduction ? user.max_deduction : delta
    end

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
