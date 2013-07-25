module SimpleCredit
  class Credit < ActiveRecord::Base
    attr_accessible :user, :value, :highest_value

    belongs_to :user
    validates :user_id, uniqueness: true
  end
end
