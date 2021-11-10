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

  def show_menu
    puts I18n.t(:guess_code)
    puts I18n.t(:hint_message, hints: @game.user_hints)
    puts I18n.t(:exit_message)
  end

  def start_guess
    show_menu
    guess = gets.chomp
    return guess_number(guess) if guess_has_only_humber?(guess)

    guess
  rescue CodebreakerGem::Error::InputRange, CodebreakerGem::Error::MaxStringLength => e
    puts e.message
    retry
  end

  def guess_has_only_humber?(guess)
    guess !~ /\D/
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
    return puts I18n.t(:hint_code, hint: @game.use_hint) if @game.user_hints.positive?

    puts I18n.t(:no_hint_message)
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
