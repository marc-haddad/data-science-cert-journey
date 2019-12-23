
# Team that scores most runs wins
# Each team has 9 batters that bat in a predetermined order
# If all batters bat, we cycle through the order again

# Plate Appearance (PA): Each time a player comes to bat
# PAs end w/ a binary outcome: 
  # Batter makes an "out" = failure
  # Batter does not make an "out" = success

# Each team gets 9 tries (Innings) to score runs
# Each inning ends after 3 outs per team

# 5 ways to succeed (i.e not make an out):
  # 1. BB = Base on balls; the pitcher threw shittily, automatic first base
  # 2. 1B = Single; hit the ball, reach first base
  # 3. 2B = Double; hit the ball, reach second base
  # 4. 3B = Triple; hit the ball, reach third base
  # 5. HR = Home run; hit the ball, reach home plate

# Most historically important offense stat: Batting Avg (BA)
# BA defined by: Hit (H), and At bat (AB)
# Hits can be Singles (1B), Doubles (2B), Triples (3B), or Home runs (HR)
# At bat (AB) is the number of times you either get a hit or make an out
# BA = H/AB

# BAs currently range b/w 20% and 38%
# BAs fail in taking BBs into account, even though they are considered a success