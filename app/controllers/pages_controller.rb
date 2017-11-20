require "open-uri"

class PagesController < ApplicationController
  def game
    @grid = (0...9).map { (65 + rand(26)).chr }
    @start_time = Time.now.to_i
  end

  def score
    @start_time = params[:start_time].to_i
    @end_time = Time.now.to_i
    @grid = params[:grid]
    @attempt = params[:attempt]
    @result = { time: (@end_time - @start_time), message: message(@attempt, @grid) }
    if english_word?(@attempt) && letter?(@attempt, @grid)
      @result[:score] = (10 - @result[:time]/10) + @attempt.size
    else
      @result[:score] = 0
    end
    @result
  end

  private

  def letter?(attempt, grid)
    array_l = attempt.upcase.chars
    array_l.each do |letter|
      return false if array_l.count(letter) > grid.count(letter)
    end
    true
  end

  def english_word?(attempt)
    dictionnary = JSON.parse(open("https://wagon-dictionary.herokuapp.com/" + attempt).read)
    dictionnary["found"]
  end

  def message(attempt, grid)
    return "Looser!" if attempt == ""
    return "Not in the grid" if letter?(attempt, grid) == false
    return "Not an english word" if english_word?(attempt) == false
    "Well Done!"
  end
end


