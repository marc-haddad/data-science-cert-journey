# Bayes' Theorem
  
  # Probability of disease test showing positive given we have disease (D=1):
    # Prob(+ | D = 1) = 0.99
  # Probability of disease test showing negative given we do not have disease (D=0):
    # Prob(- | D = 0) = 0.99

  # Bayes' Theorem states:
    # Prob A GIVEN B = Prob A AND B / Prob B
      # Pr(A | B) = Pr(A and B)/Pr(B)
    # W/ multiplication rule we get:
      # Pr(A | B) = Pr(B | A)*Pr(A)/Pr(B)

# Random person tested positive, probability they have the disease?
# Prob(D = 1 | +)
# Prob D is 1, given we have a positive test

# Given data: Prob(D = 1) = 0.00025, Prob(+ | D = 1) = 0.99
 
# Pr(D = 1 | +) = Pr(+ | D = 1) * Pr(D)/ Pr(+)
# Pr(+) = Pr(+ | D = 1) * Pr(D = 1) + Pr(+ | D = 0) * Pr(D = 0)
# Therefore: 
  # Pr(D = 1 | +) = Pr(+ | D = 1) * Pr(D) / (Pr(+ | D = 1)*Pr(D = 1) + Pr(+ | D = 0) * Pr(D = 0))
  # Pr(D = 1 | +) = 0.99 * 0.00025/(0.99 * 0.00025 + (1-0.99) * (1-0.00025))

0.99 * 0.00025/(0.99 * 0.00025 + (1-0.99) * (1-0.00025)) # 0.02

# 0.02 Chance the person has disease given the test is positive

# The reason it is so low given 99% test accuracy is because we have to factor in
# the very rare possibility that a person picked randomly has the diseas
  