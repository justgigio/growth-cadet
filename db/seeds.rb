# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Dns::Address.all.each(&:destroy)
Dns::Record.delete_all

lorem = Dns::Record.create(hostname: "lorem.com")
ipsum = Dns::Record.create(hostname: "ipsum.com")
dolor = Dns::Record.create(hostname: "dolor.com")
amet = Dns::Record.create(hostname: "amet.com")
sit = Dns::Record.create(hostname: "sit.com")

ones = Dns::Address.create(ipv4: "1.1.1.1")
ones.records << [lorem, ipsum, dolor, amet]

twos = Dns::Address.create(ipv4: "2.2.2.2")
twos.records << [ipsum]

threes = Dns::Address.create(ipv4: "3.3.3.3")
threes.records << [ipsum, dolor, amet]

fours = Dns::Address.create(ipv4: "4.4.4.4")
fours.records << [sit, ipsum, dolor, amet]

fives = Dns::Address.create(ipv4: "5.5.5.5")
fives.records << [sit, dolor]
