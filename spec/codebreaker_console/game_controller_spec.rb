# frozen_string_literal: true

RSpec.describe GameController do
  subject(:console) { described_class.new }

  let(:playstate) { instance_double(PlayState) }

  describe '#check if all statements are valid in game' do
    before do
      allow(console).to receive(:exit)
      allow(console).to receive(:loop).and_yield
      allow(I18n).to receive(:t).with(:menu)
    end

    it 'will start the game if user will write the correct command' do
      allow(I18n).to receive(:t)
      allow(console).to receive(:gets).and_return('start', 'Ivan', 'asy', 'Ivan', 'easy')
      allow(PlayState).to receive(:new).and_return(playstate)
      expect(playstate).to receive(:start)
      console.show_menu
    end

    it 'will show users statistic if user will write the correct command' do
      allow(I18n).to receive(:t)
      allow(console).to receive(:gets).and_return('stats')
      expect(console).to receive(:back_to_menu)
      console.show_menu
    end

    it 'will show wrong command message if user enter wrong command' do
      allow(console).to receive(:gets).and_return('dsadsa')
      expect(I18n).to receive(:t).with(:wrong_command)
      console.show_menu
    end

    it 'will show goodbye message from game if user enter exit' do
      allow(console).to receive(:gets).and_return('exit', 'y')
      expect(I18n).to receive(:t).with(:leave_message)
      console.show_menu
    end

    it 'will show rules for user' do
      allow(console).to receive(:gets).and_return('rules')
      expect(I18n).to receive(:t).with(:rules)
      console.show_menu
    end

    context '#empty db' do

      let(:initialized_path) { 'db' }
      let(:initialized_file) { 'database.yml' }

      before do
        File.delete(File.join(initialized_path, initialized_file))
        Dir.rmdir(initialized_path)
      end

      it 'will show empty users statistic message' do
        allow(I18n).to receive(:t)
        allow(console).to receive(:gets).and_return('stats')
        expect(console).to receive(:back_to_menu)
        console.show_menu
      end
    end
  end
end
