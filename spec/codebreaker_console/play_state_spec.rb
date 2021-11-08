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

    context '#will use user`s attempt' do
      before do
        allow(game).to receive(:gets).and_return(code)
        allow(game).to receive(:show_menu)
      end

      it 'will not raise an error if code is valid' do
        expect(game).to receive(:guess_number)
        game.start
      end
    end

    context '#when user type hint' do
      before { allow(game).to receive(:gets).and_return('hint') }

      it 'show hint code to user' do
        expect(I18n).to receive(:t)
        game.start
      end
    end

    context '#user win' do
      before do
        game.game.instance_variable_set(:@secret_code, [1, 2, 3, 4])
        allow(game).to receive(:gets).and_return(code)
      end

      it 'stop game if user win' do
        expect(game).to receive(:exit)
        game.start
      end
    end

    context '#user lose' do
      before do
        allow(game).to receive(:gets).and_return(code)
        game.game.instance_variable_set(:@user_attempts, 0)
      end

      it 'stop game if user lose' do
        expect(game).to receive(:exit)
        game.start
      end
    end

    context '#when user type close' do
      before { allow(game).to receive(:gets).and_return('exit') }

      it "will close the game if enter type 'exit'" do
        expect(game).to receive(:exit)
        game.start
      end
    end

    context '#user didn`t guess the number' do
      before { allow(game).to receive(:gets).and_return(code) }

      it 'will ask user to write number again' do
        expect(game).to receive(:back_to_start)
        game.start
      end
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
