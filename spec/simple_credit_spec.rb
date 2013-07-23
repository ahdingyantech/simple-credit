require "spec_helper"

describe SimpleCredit do
  let(:user)  {FactoryGirl.create :user}
  let(:dummy) {FactoryGirl.create :dummy_model, user: user, dummy: true}

  describe SimpleCredit::UserMethods do
    describe "#credit_value" do
      subject {user.credit_value}

      it {should be 0}
    end

    describe "#add_credit" do
      before {dummy}
      subject {user.add_credit(4, :xixi, dummy)}

      it {expect {subject}.to change {user.credit_histories.count}.by(1)}
      it {expect {subject}.to change {user.credit_value}.from(2).to(6)}
      its(:scene) {should be :xixi}
      its(:delta) {should be 4}
      its(:model) {should eq dummy}
    end
  end

  describe SimpleCredit::ModelMethods do
    describe ".record_credit" do
      it {expect {dummy}.to change {user.credit_value}.by(2)}
      it {expect {dummy.update_attributes(bla: 1)}.to change {user.credit_value}.by(4)}
      it {expect {dummy.destroy}.to change {user.credit_value}.by(4)}
    end
  end
end
