# encoding: utf-8

require 'spec_helper'

describe RuboCop::Cop::Rails::Date, :config do
  subject(:cop) { described_class.new(config) }

  context 'when EnforcedStyle is "strict"' do
    let(:cop_config) { { 'EnforcedStyle' => 'strict' } }

    %w(today current yesterday tomorrow).each do |day|
      it "registers an offense for Date.#{day}" do
        inspect_source(cop, "Date.#{day}")
        expect(cop.offenses.size).to eq(1)
      end

      it "registers an offense for ::Date.#{day}" do
        inspect_source(cop, "::Date.#{day}")
        expect(cop.offenses.size).to eq(1)
      end

      it "accepts Some::Date.#{day}" do
        inspect_source(cop, "Some::Date.#{day}")
        expect(cop.offenses).to be_empty
      end
    end

    %w(to_time to_time_in_current_zone).each do |method|
      it "registers an offense for ##{method}" do
        inspect_source(cop, "date.#{method}")
        expect(cop.offenses.size).to eq(1)
      end

      it "accepts variable named #{method}" do
        inspect_source(cop, "#{method} = 1")
        expect(cop.offenses).to be_empty
      end

      it "accepts variable #{method} as range end" do
        inspect_source(cop, "from_time..#{method}")
        expect(cop.offenses).to be_empty
      end
    end
  end

  context 'when EnforcedStyle is "flexible"' do
    let(:cop_config) { { 'EnforcedStyle' => 'flexible' } }

    %w(current yesterday tomorrow).each do |day|
      it "accepts Date.#{day}" do
        inspect_source(cop, "Date.#{day}")
        expect(cop.offenses).to be_empty
      end
    end

    it 'registers an offense for Date.today' do
      inspect_source(cop, 'Date.today')
      expect(cop.offenses.size).to eq(1)
    end

    it 'accepts #to_time_in_current_zone' do
      inspect_source(cop, 'date.to_time_in_current_zone')
      expect(cop.offenses).to be_empty
    end
  end
end
