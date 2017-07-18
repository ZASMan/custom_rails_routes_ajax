FactoryGirl.define do
  factory :project do
    name "MyString"
  end
  factory :employee do
    name "MyString"
    position "MyString"
    project_id 1
  end
end
