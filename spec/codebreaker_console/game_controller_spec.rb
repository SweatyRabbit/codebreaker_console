# frozen_string_literal: true

RSpec.describe GameController do
  subject(:console) { described_class.new }

  let(:playstate) { instance_double(PlayState) }

  describe '#check if all statements are valid in game' do
    before do
      allow(console).to receive(:exit)
      allow(console).to receive(:loop).and_yield
      allow(I18n).to receive(:t)
      allow(console).to receive(:gets).and_return('start', 'Ivan', 'asy')
      allow(PlayState).to receive(:new).and_return(playstate)
    end

    it 'will start the game if user write command start' do
      expect(playstate).to receive(:start)
      console.show_menu
    end

    context 'when user type stats' do
      context 'when db is not empty' do
        let(:stats) do
          { rating: 1,
            name: 'Ivan',
            difficulty: 'easy',
            used_attempts: '3',
            total_attempts: '15',
            used_hints: '1',
            total_hints: '2' }
        end

        before do
          allow(console).to receive(:gets).and_return('stats')
        end

        it 'will show users statistic if db is not empty' do
          expect(console).to receive(:stats_to_hash).and_return(stats)
          console.show_menu
        end
      end

      context 'when db is empty' do
        let(:initialized_path) { CodebreakerGem::Entities::CodebreakerGemStore::STORAGE_DIRECTORY }
        let(:initialized_file) { CodebreakerGem::Entities::CodebreakerGemStore::STORAGE_FILE }

        before do
          File.delete(File.join(initialized_path, initialized_file))
          Dir.rmdir(initialized_path)
          allow(console).to receive(:gets).and_return('stats')
        end

        it 'will show empty users statistic message' do
          expect(I18n).to receive(:t).with(:empty_users_statistic)
          console.show_menu
        end
      end
    end

    context 'when user type command that wasn`t in list' do
      before { allow(console).to receive(:gets).and_return('dsadsa') }

      it 'will show wrong command message' do
        expect(I18n).to receive(:t).with(:wrong_command)
        console.show_menu
      end
    end

    context 'when user type exit' do
      before { allow(console).to receive(:gets).and_return('exit', 'y') }

      it 'show goodbye message from game' do
        expect(I18n).to receive(:t).with(:leave_message)
        console.show_menu
      end
    end

    context 'when user type rules' do
      before { allow(console).to receive(:gets).and_return('rules') }

      it 'will show rules for user' do
        expect(I18n).to receive(:t).with(:rules)
        console.show_menu
      end
    end
  end
end
