require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = []
    8.to_i.times { @grid << ('a'..'z').to_a.sample }
  end

  def score
    @grid = params[:grid]
    @attempt = params[:attempt]
    attempt = @attempt.chars
    dico = call_api(@attempt)['found']
    if word_include(@grid, attempt) && dico
      @message = 'well done !'
      @score = (100 * attempt.size)
    elsif word_include(@grid, attempt) && !dico
      @message = 'not an english word'
      @score = 0
    else
      @message = 'not in the grid'
      @score = 0
    end
  end

  def word_include(grid, attempt)
    attempt.all? { |letter| attempt.count(letter) <= grid.count(letter)}
  end

  def call_api(attempt)
    filepath = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    serialized_word = URI.open(filepath).read
    JSON.parse(serialized_word)
  end
end
