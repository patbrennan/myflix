Fabricator(:video) do
  title { Faker::Book.title }
  description { Faker::SiliconValley.quote }
  category
end