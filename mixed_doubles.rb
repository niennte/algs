# require 'set'

# TODO next take try with sets
# https://ruby-doc.org/stdlib-2.5.3/libdoc/set/rdoc/Set.html#method-i-reset

def shuffle_game(quartets, played_games, courts = 5, report = true)
  shuffles = 0
  begin
    shuffles += 1
    game = []
    black_list = []

    begin
      next_p = quartets.shuffle.find do |val|

        available = true
        played_games.each do |quart|
          if (quart & val).length > 1
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
  end until (game.length == courts)
  if report
    puts 'Took ' + shuffles.to_s + ' shuffles.'
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



def solution(a, b)

  mixed = make_mixed_quartets a, b

  puts "---"
  puts 'Making games...'

  played_games = []
  puts "Shuffling game one..."
  first_game = shuffle_game mixed, played_games

  played_games += first_game
  puts 'Shuffling game two...'
  second_game = shuffle_game mixed, played_games

  played_games += second_game
  puts 'Shuffling game three...'
  third_game = shuffle_game mixed, played_games


  puts "---"

  puts "First game:"
  p first_game

  puts "Second game:"
  p second_game

  puts "Third game:"
  p third_game

  puts '---'
  'All done!!!'
end

tests = [
    {
        a: (1..10).to_a,
        b: (101..110).to_a,
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
    p solution test[:a], test[:b]
  end
end

def dump(sym, &b)
  puts "#{sym}: #{eval(sym.to_s, b.binding)}"
end

run tests