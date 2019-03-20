# require 'set'

# TODO next take try with sets
# https://ruby-doc.org/stdlib-2.5.3/libdoc/set/rdoc/Set.html#method-i-reset

def shuffle_game(quartets, played_games, courts = 5, report = true, greater_list = [])
  shuffles = 0
  allow_repeat = 1
  begin
    shuffles += 1
    game = []
    black_list = []

    begin
      next_p = quartets.shuffle.find do |val|

        available = true
        played_games.each do |quart|
          if (quart & val).length > allow_repeat
            available = false
            break
          end
        end

        (val & black_list).length == 0 && available
      end
      unless next_p.nil?
        # swap second woman with first man, to form mixed teams
        next_p[1], next_p[2] = next_p[2], next_p[1]

        game.push next_p
        black_list += next_p
      end
    end until next_p.nil?

    # uncomment to allow 1 player repetition
    # if (shuffles > 100) && (game.length < courts)
    #   return game
    #   shuffles = 0
    #   allow_repeat += 1
    #   if report
    #     puts 'Allowing ' + allow_repeat.to_s + ' players to repeat at court ' + game.length.to_s
    #   end
    # end

  end until (game.length == courts)
  if report
    puts 'Took ' + shuffles.to_s + ' shuffles.'
  end

  if greater_list.length > 0
    game.push (greater_list - black_list)
  end

  game
end

def make_mixed_quartets(a, b, report = true)
  union = a + b
  quartets = union.combination(4).to_a
  if report
    puts 'Found ' + quartets.length.to_s + ' quartets.'
  end

  mixed = quartets.select{ |quart| (quart.sum > 200) && (quart.sum < 300) }
  if report
    puts 'Found ' + mixed.length.to_s + ' quartets for mixed doubles.'
  end
  mixed
end



def solution(a, b, courts)

  mixed = make_mixed_quartets a, b

  puts "---"
  puts 'Making games...'

  played_games = []
  puts "Shuffling game one..."
  first_game = shuffle_game mixed,  played_games, courts, true, b

  played_games += first_game
  puts 'Shuffling game two...'
  second_game = shuffle_game mixed, played_games, courts, true, b

  played_games += second_game
  puts 'Shuffling game three...'
  third_game = shuffle_game mixed, played_games, courts, true, b


  puts "---"

  puts "First game:"
  p first_game

  puts "Second game:"
  p second_game

  puts "Third game:"
  p third_game

  puts '---'

  puts "Report for the non-mixed court (last) - "
  puts "players appearing in the non-mixed court more than once: "
  one_two = first_game[first_game.length - 1] & second_game[first_game.length - 1]
  one_three = first_game[first_game.length - 1] & third_game[third_game.length - 1]
  two_three = second_game[second_game.length - 1] & third_game[third_game.length - 1]
  p (one_two | one_three | two_three)

  'All done!!!'
end

tests = [
    # {
    #     a: (1..10).to_a,
    #     b: (101..110).to_a,
    #     courts: 5,
    # },
    {
        a: (1..6).to_a,
        b: (101..110).to_a,
        courts: 3,
    },
    # {
    #     a: [1,2,1,5,0]
    # },
]

def run(tests)

  tests.each do |test|
    puts 'Female players: '
    p test[:a]
    puts 'Male players: '
    p test[:b]
    puts 'Processing...'
    puts '---'
    p solution test[:a], test[:b], test[:courts]
  end
end

def dump(sym, &b)
  puts "#{sym}: #{eval(sym.to_s, b.binding)}"
end

run tests