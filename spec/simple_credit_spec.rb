require "spec_helper"

describe SimpleCredit do
  let(:user)  {FactoryGirl.create :user}

  describe SimpleCredit::UserMethods do
    describe "#credit_value" do
      subject {user.credit_value}

      it {should be 0}
    end
  end

  describe SimpleCredit::ModelMethods do
    describe ".record_credit" do
      let(:dummy) {FactoryGirl.create :dummy_model, user: user, dummy: true}

      it {expect {dummy}.to change {user.credit_value}.by(2)}
      it {expect {dummy.update_attributes(bla: 1)}.to change {user.credit_value}.by(4)}
      it {expect {dummy.destroy}.to change {user.credit_value}.by(4)}
    end
  end
end
