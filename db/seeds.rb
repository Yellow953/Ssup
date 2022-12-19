User.create(
    email: "test@test.com",
    password: "qwe123"
)

2.times do
    User.create(
        email: Faker::Internet.email,
        password: "qwe123"
    )
end

3.times do
    Room.create(
        name: Faker::ProgrammingLanguage.name
    )
end