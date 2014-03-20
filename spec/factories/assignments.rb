# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :assignment do
    name "MyString"
    score "9.99"
    total "9.99"
    user_id 1
  end
end
