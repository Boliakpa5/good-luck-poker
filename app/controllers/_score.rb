# constantes :
SUITS = "cdhs"

FACES = "23456789TJQKA"

SUIT_LOOKUP = {
  'c' => 0,
  'd' => 1,
  'h' => 2,
  's' => 3
}

FACE_VALUES = {
  '2' =>  1,
  '3' =>  2,
  '4' =>  3,
  '5' =>  4,
  '6' =>  5,
  '7' =>  6,
  '8' =>  7,
  '9' =>  8,
  'T' =>  9,
  'J' => 10,
  'Q' => 11,
  'K' => 12,
  'A' => 13
}

DECK = ["2c", "2d", "2h", "2s", "3c", "3d", "3h", "3s", "4c", "4d", "4h", "4s", "5c", "5d", "5h", "5s", "6c", "6d", "6h", "6s", "7c", "7d", "7h", "7s", "8c", "8d", "8h", "8s", "9c", "9d", "9h", "9s", "Tc", "Td", "Th", "Ts", "Jc", "Jd", "Jh", "Js", "Qc", "Qd", "Qh", "Qs", "Kc", "Kd", "Kh", "Ks", "Ac", "Ad", "Ah", "As"
]

# main en début de tour
hand = []
# je pioche
hand << ["7h", "8d"]
# j'ajoute les cartes de la table
hand << ["9h", "3h", "5c", "8h", "Ks"]
# je check que tout est bon
# p hand.flatten!
# puts hand.size
hand = ["7h", "8d", "9h", "3h", "5c", "8h", "Ks"]



require 'rubygems'
require 'ruby-poker'

hand2 = PokerHand.new(["7h", "8d", "9h", "kh", "ks", "ks", "Ks"])
hand1 = PokerHand.new(["7h", "8d", "9h", "3h", "5c", "8h", "Ks"])
hand3 = PokerHand.new(["7h", "8d", "TC", "JC", "QC", "KC", "AC"])
hand4 = PokerHand.new(["7h", "8d", "9h", "3h", "5c", "2h", "Ks"])
hand5 = PokerHand.new(["7h", "8d", "9h", "3h", "5c", "8h", "Ks"])
hand6 = PokerHand.new(["7h", "8d", "9h", "3h", "5c", "8h", "Ks"])
# puts hand1.rank
# puts hand1.by_suit
# puts hand1.face_values
# puts hand1.hand_rating
# puts hand2.hand_rating
# puts hand1.sort_using_rank
# puts hand1 > hand2
# p hand1.score
# p hand2.score
# p hand3.score
p hand4.score[0]
hand = hand4.score[0].map { |i| i.to_s }
hand = hand.map do |num|
  if num.to_i < 10
    "0" + num
  else
    num
  end
end
hand[0] = hand[0] + "."
hand = hand.join()
hand = hand.to_f
p hand



# case hand.hand_rating
# when "Royal Flush"
#   hand.value = 9
# when 'Straight Flush'
#   hand.value = 8
# when 'Four of a kind'
#   hand.value = 7
# when 'Full house'
#   hand.value = 6
# when 'Flush'
#   hand.value = 5
# when 'Straight'
#   hand.value = 4
# when 'Three of a kind'
#   hand.value = 3
# when 'Two pair'
#   hand.value = 2
# when 'Pair'
#   hand.value = 1
# when 'Highest Card'
#   hand.value = 0
# else
#   hand.value = 0
# end
