# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build :user }

  describe "validations" do
    it { should allow_value(nil).for(:password) }
    it { should validate_length_of(:password).is_at_least(8) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_presence_of(:session_token) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
  end
  
  describe "::find_by_credentials" do
    before do
      @user = create :user
    end

    context "with correct username and password" do
      it "returns the user" do
        expect(User.find_by_credentials(@user.username, @user.password)).to eq(User.last)
      end
    end

    context "with correct username and incorrect password" do
      it "returns falsy" do
        expect(User.find_by_credentials(@user.username, "")).to be_falsy
      end
    end

    context "with incorrect username and password" do
      it "returns falsy" do
        expect(User.find_by_credentials("", @user.password)).to be_falsy
      end
    end

    context "with incorrect username and correct password" do
      it "returns falsy" do
        expect(User.find_by_credentials("", "")).to be_falsy
      end
    end
  end

  describe "::generate_session_token" do
    it "calls SecureRandom::urlsafe_base64" do
      expect(SecureRandom).to receive(:urlsafe_base64)
      User.generate_session_token
    end
  end

  describe "#ensure_session_token" do
    context "when session token" do
      it "doesn't change session token" do
        user = create :user
        expect do
          user.ensure_session_token
        end.to_not change(user, :session_token)
      end
    end

    context "when no session token" do
      it "sets session token" do
        user = build :user
        user.ensure_session_token
        expect(user.session_token).to_not be_nil
      end

    end
  end

  describe "#new" do
    it "automatically creates session token" do
      expect(User.new.session_token).to_not be_nil
    end
  end

  describe "#is_password?" do
    context "when correct password" do
      it "returns truthy" do
        password = user.password
        expect(user.is_password?(password)).to be_truthy
      end
    end

    context "when incorrect password" do
      it "returns falsy" do
        expect(user.is_password?("anystring")).to be_falsy
      end
    end
  end

  describe "#password=" do
    it "assigns @password" do
      user.password = "whatever"
      expect(user.password).to eq("whatever")
    end

    it "assigns password_digest" do
      expect do
        user.password = "whatever"
      end.to change(user, :password_digest)
    end

    it "doesn't save plain password" do
      user = build :user
      user.save
      expect(user.password_digest).to_not eq(user.password)
    end
  end

  describe "#reset_session_token!" do
    it "changes the session token" do
      expect do
        user.reset_session_token!
      end.to change(user, :session_token)
    end

    it "delegates to ::generate_session_token" do
      expect(User).to receive(:generate_session_token).twice
      user.reset_session_token!
    end

    it "calls save" do
      user = build :user
      expect(user).to receive(:save)
      user.reset_session_token!
    end

    it "returns session token" do
      expect(user.reset_session_token!).to eq(user.session_token)
    end
  end
end
