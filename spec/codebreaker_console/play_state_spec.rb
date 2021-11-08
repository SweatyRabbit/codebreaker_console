# frozen_string_literal: true

RSpec.describe PlayState do
  subject(:game) { described_class.new(name, difficulty) }

  let(:name) { 'Ivan' }
  let(:difficulty) { 'easy' }
  let(:code) { '1234' }

  describe '#empty hints' do
    before do
      allow(game).to receive(:loop).and_yield
      allow(game).to receive(:show_menu)
      allow(game).to receive(:gets).and_return('hint')
      game.game.instance_variable_set(:@user_hints, 0)
    end

    it 'show message for empty hints' do
      expect(I18n).to receive(:t)
      game.start
    end
  end

  describe '#test game' do
    before do
      allow(game).to receive(:exit)
      allow(game).to receive(:loop).and_yield
      allow(I18n).to receive(:t)
    end

    it 'will not raise an error if code is valid' do
      allow(game).to receive(:gets).and_return(code)
      allow(game).to receive(:show_menu)
      expect(game).to receive(:guess_number)
      game.start
    end

    it 'will not raise an error if hint is used' do
      allow(game).to receive(:gets).and_return('hint')
      expect(I18n).to receive(:t)
      game.start
    end

    context '#user win' do
      before { game.game.instance_variable_set(:@secret_code, [1, 2, 3, 4]) }

      it 'will not raise an error if user has won' do
        allow(game).to receive(:gets).and_return(code)
        expect(game).to receive(:exit)
        game.start
      end
    end

    context '#user lose' do
      before do
        game.game.instance_variable_set(:@user_attempts, 0)
      end

      it 'user will lose if his attempts will be equal to zero' do
        allow(game).to receive(:gets).and_return(code)
        expect(game).to receive(:exit)
        game.start
      end
    end

    it "will close the game if enter type 'exit'" do
      allow(game).to receive(:gets).and_return('exit')
      expect(game).to receive(:exit)
      game.start
    end

    it 'when user don`t win and lose' do
      allow(game).to receive(:gets).and_return(code)
      expect(game).to receive(:back_to_start)
      game.start
    end
  end

  describe '#will ask user to write right number' do
    before do
      allow(game).to receive(:loop).and_yield
      allow(game).to receive(:gets).and_return('123')
      allow(game).to receive(:show_menu)
    end

    it 'will raise error if code is not valid' do
      game.start
      expect { game }.to raise_error
    end
  end
end
