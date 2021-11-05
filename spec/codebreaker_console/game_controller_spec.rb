# frozen_string_literal: true

RSpec.describe GameController do
  subject(:console) { described_class.new }

  describe '#check if all statements are valid in game' do
    before do
      allow(console).to receive(:exit)
      allow(console).to receive(:loop).and_yield
      allow(I18n).to receive(:t)
    end

    it 'will start the game if user will write the correct command' do
      allow(console).to receive(:gets).and_return('start')
      expect(console).to receive(:start_game)
      console.show_menu
    end

    it 'will show users statistic if user will write the correct command' do
      allow(console).to receive(:gets).and_return('stats')
      expect(console).to receive(:show_statistic)
      console.show_menu
    end

    it 'will show wrong command message if user enter wrong command' do
      allow(console).to receive(:gets).and_return('dsadsa')
      expect(console).to receive(:wrong_command)
      console.show_menu
    end

    it 'will show goodbye message from game if user enter exit' do
      allow(console).to receive(:gets).and_return('exit')
      expect(console).to receive(:exit_command)
      console.show_menu
    end

    it 'will show rules for user' do
      allow(console).to receive(:gets).and_return('rules')
      expect(console).to receive(:show_rules)
      console.show_menu
    end

    it 'wrong command message' do
      expect(console).to receive(:show_menu)
      console.wrong_command
    end

    it 'rules message' do
      expect(console).to receive(:show_menu)
      console.show_rules
    end

    it 'exit from game' do
      allow(console).to receive(:gets).and_return('y')
      expect(console).to receive(:exit)
      console.exit_command
    end

    let(:playstate) { instance_double(PlayState) }

    it 'start the game if user enter right name and difficulty' do
      allow(console).to receive(:gets).and_return('Ivan', 'easy')
      allow(PlayState).to receive(:new).with('Ivan', 'easy').and_return(playstate)
      expect(playstate).to receive(:start)
      console.start_game
    end

    it 'show statistic' do
      expect(console).to receive(:show_menu)
      console.show_statistic
    end
  end
end
