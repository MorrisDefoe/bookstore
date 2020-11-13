FactoryBot.define do
  factory :user do
    first_name { FFaker::Name.first_name }
    last_name  { FFaker::Name.last_name }
    address { FFaker::Address.country }
    email { FFaker::Internet.email }
    password { FFaker::Internet.password }

    trait :with_order do
      after(:build) do |user|
        user.users_orders << FactoryBot.build(:users_order)
      end
    end
  end


  factory :book do
    author { FFaker::Book.author }
    title { FFaker::Book.title }
    genre { FFaker::Book.genre }
    quantity { FFaker::Random.rand(15)}
  end

  factory :users_order do
    user_id {FFaker::Random.rand(100)}
    book_id {FFaker::Random.rand(100)}
    status {'ordered'}
  end
end