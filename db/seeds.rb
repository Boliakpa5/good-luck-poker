# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

PokerTable.create(name: "First Table", max_players: 5, small_blind: 1)
PokerTable.create(name: "Other Table", max_players: 7, small_blind: 5)
PokerTable.create(name: "Final Table", max_players: 9, small_blind: 10)

# t.string "name"
#     t.integer "max_players"
#     t.integer "small_blind"
