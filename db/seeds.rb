puts 'Creating poker tables...'
PokerTable.create(name: "First Table", max_players: 5, small_blind: 1)
PokerTable.create(name: "Other Table", max_players: 7, small_blind: 5)
PokerTable.create(name: "Final Table", max_players: 9, small_blind: 10)
puts 'Done!'
puts 'Creating users...'
User.create(email: "francoispaillon@hotmail.fr", password: "coucou", nickname: "Francois", balance: 50000)
User.create(email: "etienne.klepal@gmail.com", password: "coucou", nickname: "Etienne", balance: 50000)
puts 'Done'
