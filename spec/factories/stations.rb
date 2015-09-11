FactoryGirl.define do
  factory :station do
    sequence(:name) { |n| "Station#{n}" }
  end

end
