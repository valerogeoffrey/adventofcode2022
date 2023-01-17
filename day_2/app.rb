require_relative 'input'

def scoring(input = nil)
  # Rock Paper Scissors is a game between two players
  # Rock defeats Scissors, Scissors defeats Paper, and Paper defeats Rock
  # If both players choose the same shape match nul
  # A for Rock, B for Paper, and C for Scissors
  # The second column, you reason, must be what you should play in response: X for Rock, Y for Paper, and Z for Scissors
  # The winner of the whole tournament is the player with the highest score
  # Your total score is the sum of your scores for each round
  # The score for a single round is the score for the shape you selected
  # (1 for Rock, 2 for Paper, and 3 for Scissors) plus the score for the outcome of the round
  # (0 if you lost, 3 if the round was a draw, and 6 if you won).

  move_first = { Rock: :A, Paper: :B, Scissors: :C }
  move_second = { Rock: :X, Paper: :Y, Scissors: :Z }

  ending = { X: :loose, Y: :eq, Z: :win }

  dep = { A: :X, C: :Z, B: :Y }
  battle = { A: [:C, :Z], C: [:B, :Y], B: [:A, :X], X: [:C, :Z], Z: [:B, :Y], Y: [:A, :X] }
  points_ref = { A: 1, X: 1, B: 2, Y: 2, C: 3, Z: 3 }
  _win_lost_point = { win: 6, equal: 3, lost: 0 }

  sum_points = fetch_input.split("\n").map { |game| game.split(' ') }.map do |game|
    points = points_ref[game.last.to_sym]

    if dep[game.first.to_sym] == game.last.to_sym
      points += 3
    end

    if battle[game.last.to_sym].include?(game.first.to_sym)
      points += 6
    end

    points
  end.sum
  pp sum_points
end

def scoring_2(input = nil)
  ending = { X: :loose, Y: :eq, Z: :win }
  points_ref = { A: 1, B: 2, C: 3}
  battle = { A: :C, C: :B, B: :A}

  sum_points = fetch_input.split("\n").map { |game| game.split(' ') }.map do |game|
    points = 0
    move_1 = game.first.to_sym
    case ending[game.last.to_sym]
    when :loose
      points += points_ref[battle[move_1]]
    when :eq
      points += (points_ref[move_1] + 3)
    when :win
      mv = ([:A, :B, :C] - [battle[move_1]] - [move_1]).first
      points += (points_ref[mv] + 6)
    else
      0
    end

    points
  end.sum
  pp sum_points
end

#scoring(fetch_input)
scoring_2(fetch_input)