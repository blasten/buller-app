require 'spec_helper'

describe Assignment do
  describe "#percentage" do
    specify do
      assignment = Assignment.new(score: 5, total: 10)
      expect(assignment.percentage).to eq(50)
    end
  end
 
  describe ".average" do
    specify do
      # We need a temporary user because the `Assignment` model validates that the user is a `student`
      @student = User.create(email: "test@apple.com", name: "test", nickname: "test", password: "test", password_confirmation: "test")

      Assignment.create(name: "Assignment 1", score: 8, total: 10, user: @student)
      Assignment.create(name: "Assignment 2", score: 4, total: 10, user: @student)
      expect(Assignment.average_percentage).to eq(60)
    end
  end
end
