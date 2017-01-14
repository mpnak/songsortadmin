FactoryGirl.define do
  factory :station do
    sequence(:name) { |n| "Station#{n}" }

    after(:create) do |instance|
      100.times do
        instance.tracks << FactoryGirl.create(:track, station: instance)
      end
    end
  end
end
