library(gtools)
suits = c("Diamonds", "Spades", "Clubs", "Hearts")
numbers = c("Ace", "Deuce", "Three", "Four", "Five", "Six", "Seven",
            "Eight", "Nine", "Ten", "Jack", "Queen", "King")
deck = expand.grid(number = numbers, suit = suits)
deck = paste(deck$number, deck$suit)

# Probabilty of drawing king
kings = paste("King", suits)
p_1 = mean(deck %in% kings)

# 'Permutations()' example from 'gtools' w/ no repeating digits
all_phone_numbers = permutations(10, 7, v = 0:9)

# All possible combinations when drawing any 2 cards w/o replacement
hands = permutations(52, 2, v = deck)

# Grabs first and second columns in 'hands'
first_card = hands[,1]
second_card = hands[,2]

# Number of cases first card is a 'king', given all possible cases
n_of_king_1 = sum(first_card %in% kings)

# Probability of drawing king after first (without replacement)
p_2 = sum(first_card %in% kings & second_card %in% kings) / sum(first_card %in% kings)
# 'p_2' gives us 3 / 51
p_2

# 'Combinations()' is similar to 'Permutations()', but order does not matter
# i.e '1, 2' & '2, 1' are considered the same in 'Combinations()', but different in 'Permutations()'
perm_ex = permutations(3, 2)
comb_ex = combinations(3, 2)

perm_ex
comb_ex

# Predicting the prob of getting an 'Ace' and any card w/ value = 10
aces = paste("Ace", suits)
facecard = c("King", "Queen", "Jack", "Ten")
facecard = expand.grid(number = facecard, suit = suits)
facecard = paste(facecard$number, facecard$suit) # All possible facecards

hands = combinations(52, 2, v = deck) # All possible combinations of any 2 cards
first_card = hands[,1] # All possible first cards
second_card = hands[,2] # All possible second cards

# Probability h1 and h2 either have a combination of a facecard and an ace
p_3 = mean(first_card %in% aces & second_card %in% facecard)
p_3

# Can also use Monte Carlo to estimate probability of natural 21
# by picking 2 cards from the dack over and over and count how many times
# we get 21
B = 10000
results = replicate(B, {
  hand = sample(deck, 2)
  (hand[1] %in% aces & hand[2] %in% facecard) | # Checks condition and evaluates as True if satisfied
  (hand[2] %in% aces & hand[1] %in% facecard)
})
# Average of 'True' evaluations over 10,000 tests
mean(results)
