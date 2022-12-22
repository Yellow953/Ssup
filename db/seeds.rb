User.create(
    email: "test@test.com",
    password: "qwe123"
)

4.times do
    User.create(
        email: Faker::Internet.email,
        password: "qwe123"
    )
end

Room.create(name: "Testing")