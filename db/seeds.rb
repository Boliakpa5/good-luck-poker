PlayerHand.destroy_all
Player.destroy_all
User.destroy_all
TableHand.destroy_all
PokerTable.destroy_all

puts 'Creating poker tables...'
PokerTable.create(name: "Tablo-Picasso", max_players: 5, small_blind: 1)
PokerTable.create(name: "CarTable", max_players: 5, small_blind: 5)
PokerTable.create(name: "BlablaTable", max_players: 7, small_blind: 1)
PokerTable.create(name: "AirTableNTable", max_players: 7, small_blind: 5)
PokerTable.create(name: "ActionTable", max_players: 9, small_blind: 5)
PokerTable.create(name: "Tabulation", max_players: 9, small_blind: 10)
puts 'Done!'
puts 'Creating users...'
User.create(email: "c2cheffontaines@gmail.com", password:"coucou", nickname: "LuckyChris", balance: 50000)
User.create(email: "francoispaillon@hotmail.fr", password: "coucou", nickname: "Francois", balance: 50000)
User.create(email: "etienne.klepal@gmail.com", password: "coucou", nickname: "Etienne", balance: 50000)
etienne = User.last
puts 'Creating players...'
Player.create(user: etienne, poker_table: PokerTable.last, stack:100, position: 1)
puts 'Creating table hands...'
TableHand.create(poker_table: PokerTable.last, first_player_position: 1, current_player_position: 3, current_call_amount: 0, status: "end")
puts 'Creating player hands...'
30.times { PlayerHand.create(player: Player.last, player_card1: "2S", player_card2: "7H", table_hand: TableHand.last, combination: [0,14,10,8,7,3]) }
puts 'Done'
