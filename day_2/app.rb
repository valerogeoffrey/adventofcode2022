require_relative 'input'

def scoring(input = nil)
  move_first = { Rock: :A, Paper: :B, Scissors: :C }
  move_second = { Rock: :X, Paper: :Y, Scissors: :Z }

  ending = { X: :loose, Y: :eq, Z: :win }

  dep = { A: :X, C: :Z, B: :Y }
  battle = { A: [:C, :Z], C: [:B, :Y], B: [:A, :X], X: [:C, :Z], Z: [:B, :Y], Y: [:A, :X] }
  points_ref = { A: 1, X: 1, B: 2, Y: 2, C: 3, Z: 3 }
  _win_lost_point = { win: 6, equal: 3, lost: 0 }

  sum_points = fetch_input.split("\n").map { |game| game.split(' ') }.map do |game|
    points = points_ref[game.last.to_sym]
    points += 3 if dep[game.first.to_sym] == game.last.to_sym
    points += 6 if battle[game.last.to_sym].include?(game.first.to_sym)
    points
  end.sum
  pp sum_points
end

def scoring_2(input = nil)
  ending = { X: :loose, Y: :eq, Z: :win }
  points_ref = { A: 1, B: 2, C: 3 }
  battle = { A: :C, C: :B, B: :A }

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