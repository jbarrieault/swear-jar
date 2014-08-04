# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tweet do
    user_id 1
    content "MyString"
    time "MyString"
  end
end
