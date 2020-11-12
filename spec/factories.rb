FactoryBot.define do
  factory :user do
    first_name { FFaker::Name.first_name }
    last_name  { FFaker::Name.last_name }
    address { FFaker::Address.country }
    email { FFaker::Internet.email }
    password { FFaker::Internet.password }
  end

    factory :book do
    author { FFaker::Book.author }
    title { FFaker::Book.title }
    genre { FFaker::Book.genre }
    quantity { FFaker::Random.rand(15)}
  end
end