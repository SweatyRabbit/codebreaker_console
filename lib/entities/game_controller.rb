# frozen_string_literal: true

class GameController
  def initialize
    puts I18n.t(:introduction)
  end

  def show_menu
    loop do
      command = user_command
      case command.downcase
      when 'start' then start_game
      when 'stats' then show_statistic
      when 'rules' then puts I18n.t(:rules)
      when 'exit' then exit_command
      else puts I18n.t(:wrong_command)
      end
    end
  end

  private

  def user_command
    puts I18n.t(:menu)
    gets.chomp
  end

  def exit_command
    puts I18n.t(:leave_message)
    exit if gets.chomp == 'y'
  end

  def start_game
    puts I18n.t(:registration_message)
    name = gets.chomp
    puts I18n.t(:difficulty_message)
    level = gets.chomp
    PlayState.new(name, level).start
  rescue CodebreakerGem::Error::NameLength, CodebreakerGem::Error::DifficultyHandler => e
    puts e.message
    retry
  end

  def show_statistic
    stats = CodebreakerGem::Entities::Game.users_statistic
    return empty_statistic if stats.empty?

    puts I18n.t(:users_statistic_head)
    formated_state = stats.map.each_with_index do |stat, index|
      I18n.t(:users_statistic, **stats_to_hash(index, stat))
    end
    puts formated_state
    back_to_menu
  end

  def empty_statistic
    puts I18n.t(:empty_users_statistic)
    back_to_menu
  end

  def stats_to_hash(index, stat)
    {
      rating: index + 1,
      name: stat.name.name,
      difficulty: stat.difficulty.level,
      used_attempts: stat.attempts,
      total_attempts: stat.difficulty.attempts,
      used_hints: stat.hints,
      total_hints: stat.difficulty.hints
    }
  end

  def back_to_menu
    show_menu
  end
end
