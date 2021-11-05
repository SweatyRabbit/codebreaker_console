# frozen_string_literal: true

class PlayState
  attr_reader :game

  def initialize(name, level)
    @game = CodebreakerGem::Entities::Game.new(name, level)
  end

  def start
    loop do
      guess = start_guess
      case guess
      when 'hint' then use_hint
      when 'exit' then exit
      else puts I18n.t(:wrong_command_for_guess)
      end
    end
  end

  private

  def start_guess
    show_menu
    guess = gets.chomp
    return guess_number(guess) if guess !~ /\D/

    guess
  rescue CodebreakerGem::Error::InputRange, CodebreakerGem::Error::MaxStringLength => e
    puts e.message
    retry
  end

  def show_menu
    puts I18n.t(:guess_code)
    puts I18n.t(:hint_command, hint: @game.user_hints)
    puts I18n.t(:exit_message)
  end

  def guess_number(guess)
    puts @game.use_attempt(guess)
    if @game.win?
      win
    elsif @game.lose?
      lose
    else
      start
    end
  end

  def use_hint
    puts I18n.t(:hint_code, hint: @game.use_hint) if @game.user_hints.positive?
  end

  def win
    puts I18n.t(:win_message)
    @game.save_current_statistic
    exit
  end

  def lose
    puts I18n.t(:lose_message, code: @game.secret_code.join.to_s)
    exit
  end
end
