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


require 'rubygems'
require 'ruby-poker'


# combinaisons
# hand1 = PokerHand.new(["Ah", "Kh", "Qh", "Th", "Jh"])
# hand2 = PokerHand.new(["2h", "3h", "4h", "5h", "6h"])
# hand3 = PokerHand.new(["2h", "2d", "2c", "2s", "3h"])
# hand4 = PokerHand.new(["2h", "2h", "2c", "3s", "3h"])
# hand5 = PokerHand.new(["2h", "3h", "4h", "5h", "7h"])
# hand6 = PokerHand.new(["2h", "3s", "4h", "5c", "6h"])
# hand7 = PokerHand.new(["2h", "2d", "2h", "3h", "4c"])
# hand8 = PokerHand.new(["2h", "2d", "3h", "3h", "4c"])
# hand9 = PokerHand.new(["2h", "2d", "3h", "4h", "6c"])

hand1 = PokerHand.new(["2h", "3d", "3h", "4h", "6c"])
hand2 = PokerHand.new(["2h", "3d", "3h", "4h", "6c"])
hand3 = PokerHand.new(["2h", "3d", "3h", "4h", "6c"])
hand4 = PokerHand.new(["2h", "2h", "2c", "3s", "3h"])
hand5 = PokerHand.new(["2h", "3h", "4h", "5h", "7h"])
hand6 = PokerHand.new(["2h", "3s", "4h", "5c", "6h"])
hand7 = PokerHand.new(["2h", "2d", "2h", "3h", "4c"])
hand8 = PokerHand.new(["2h", "2d", "3h", "3h", "4c"])
hand9 = PokerHand.new(["2h", "2d", "3h", "4h", "6c"])

handp = PokerHand.new(["Ah"])


p hand1.score[0]
p hand2.score[0]
p hand3.score[0]
p hand4.score[0]
p hand5.score[0]
p hand6.score[0]
p hand7.score[0]
p hand8.score[0]
p hand9.score[0]



score = handp.score[0]
    score = score.map { |i| i.to_s }
    score = score.map do |num|
      if num.to_i < 10
        "0" + num
      else
        num
      end
    end
    score[0] = score[0] + "."
    score = score.join()
    score = score.to_f
    p score
    p






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
