# frozen_string_literal: true

RSpec.describe PlayState do
  subject(:game) { described_class.new(name, difficulty) }

  let(:name) { 'Ivan' }
  let(:difficulty) { 'easy' }
  let(:code) { '1234' }

  describe '#test with show menu' do
    it 'will nor raise an error if class is created successfully' do
      allow(game).to receive(:loop).and_yield
      allow(I18n).to receive(:t)
      game.show_menu
    end
  end

  describe '#test game' do
    before do
      allow(game).to receive(:exit)
      allow(game).to receive(:loop).and_yield
      allow(game).to receive(:show_menu)
      allow(I18n).to receive(:t)
    end

    it 'will not raise an error if code is valid' do
      allow(game).to receive(:gets).and_return(code)
      expect(game).to receive(:guess_number)
      game.start
    end

    it 'will not raise an error if hint is used' do
      allow(game).to receive(:gets).and_return('hint')
      expect(game).to receive(:use_hint)
      game.start
    end

    context '#user win' do
      before do
        game.game.instance_variable_set(:@secret_code, [1, 2, 3, 4])
      end

      it 'will not raise an error if user has won' do
        allow(game).to receive(:gets).and_return(code)
        expect(game).to receive(:win)
        game.start
      end
    end

    context '#user lose' do
      before do
        game.game.instance_variable_set(:@user_attempts, 0)
      end

      it 'user will lose if his attempts will be equal to zero' do
        allow(game).to receive(:gets).and_return(code)
        expect(game).to receive(:lose)
        game.start
      end
    end

    it "will close the game if enter type 'exit'" do
      allow(game).to receive(:gets).and_return('exit')
      expect(game).to receive(:exit)
      game.start
    end

    it 'when user don`t win and lose' do
      expect(game).to receive(:start)
      game.guess_number(code)
    end
  end

  describe '#show win and lose message' do
    it 'win message' do
      expect(game).to receive(:exit)
      game.win
    end

    it 'lose message' do
      expect(game).to receive(:exit)
      game.lose
    end
  end

  describe '#show hint number for user' do
    it 'hint number' do
      game.use_hint
    end
  end

  describe '#will ask user to write right number' do
    before '#raise error' do
      allow(game).to receive(:loop).and_yield
      allow(game).to receive(:gets).and_return('123')
      allow(game).to receive(:show_menu)
    end

    it 'will raise error if code is not valid' do
      game.start_guess
      expect { game }.to raise_error
    end
  end
end
