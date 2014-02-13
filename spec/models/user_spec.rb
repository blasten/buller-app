require 'spec_helper'

FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "user Name #{n}"}
    sequence(:email) {|n| "test-#{n}@example.com"}
    sequence(:nickname) {|n| "Random nickname #{n}"}
    password "password"
    password_confirmation "password"
  end
end

describe User do
  let(:now) { Date.today }

  describe ".in_seat" do
    let!(:user_in_seat_1) do
      attendance = create(:attendance, attended_on: now, seat: 1)
      create(:user, attendances: [attendance])
    end

    let!(:user_in_seat_2) do
      attendance = create(:attendance, attended_on: now, seat: 2)
      create(:user, attendances: [attendance])
    end

    let!(:absent_user) do
      attendance = create(:attendance, attended_on: now - 1.day, seat: 1)
      create(:user, attendances: [attendance])
    end

    specify do
      users = User.in_seat(1, now)
      expect(users).to include(user_in_seat_1)
      expect(users).to_not include(user_in_seat_2)
      expect(users).to_not include(absent_user)
    end
  end

  describe ".absent" do
    let!(:present_user) do
      attendance = create(:attendance, attended_on: now, seat: 1)
      create(:user, attendances: [attendance])
    end

    let!(:absent_user) do
      attendance = create(:attendance, attended_on: now - 1.day, seat: 1)
      create(:user, attendances: [attendance])
    end

    specify do
      users = User.absent(now)
      expect(users).to include(absent_user)
      expect(users).to_not include(present_user)
    end
  end
end
