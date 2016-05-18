require 'csv'

module Codebreaker
  class Game

    attr_accessor :secret_code

    def initialize
      @secret_code = 4.times.map{rand(1..6)}
      @attempts = 10
      @statistics = [0,0,0,0,0]
    end

    def guess(player_code)
      if @attempts == 0
        save_result
        puts "#{@user}, do you want to restart the game(yes/no)?"
        choise = gets.chomp
        choise == "yes" ? restart_the_game : (puts "Good bye!")
      else
        @attempts -= 1  unless @attempts <= 0
        attempt_code = player_code.each_char.map{ |i| i.to_i }
        answer = {}

        for i in 0..3
          if @secret_code.at(i) == attempt_code.at(i)
            answer[i] = "+"
          end
        end

        secret = Hash[(0...@secret_code.size).zip(@secret_code)]
        attempt = Hash[(0...attempt_code.size).zip(attempt_code)]

        vars = [attempt, secret]

        vars.each do |var|
          var.delete_if do |key,value|
            key = answer[key]
         end
        end

        attempt.each_value do |value|
          if secret.has_value?(value)
            i += 10
            answer[i] = "-"
          end
        end

        @result = ""

        answer.each_value do |value|
          @result << value
        end

        index = @result.scan('+').size - 1
        @statistics[index] += 1
        return @result
      end
    end

    def hint
      return @hint if @hint
      result_hint = "****"
      num = rand(0..3)
      result_hint[num] = @secret_code[num].to_s
      return @hint = result_hint
    end

    def restart_the_game
      @attempts = 10
      @statistics = [0,0,0,0]
      puts "You now have 10 attempts. Have a nice game!"
    end

    def save_result
      puts "Enter your name"
      @user = gets.chomp
      for_save = []
      for_save << @user
      @statistics.each { |el| for_save << el }
      for_save << Time.now
      CSV.open("statistics.csv", 'a+'){ |csv| csv << for_save }
    end

    def get_statistics
      data = CSV.read("statistics.csv", headers:true)
      data.map { |d| d.to_hash }
    end

  end
end
