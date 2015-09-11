FactoryGirl.define do
  factory :song do
    station
    spotify_id { Faker::Bitcoin.address }
    name { Faker::Book.title }
    artist { Faker::Book.author }
    undergroundness { [nil, 1, 2, 3, 4, 5].sample }
  end

end
