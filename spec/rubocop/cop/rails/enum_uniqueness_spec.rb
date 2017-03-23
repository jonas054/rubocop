# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::Rails::EnumUniqueness, :config do
  subject(:cop) { described_class.new }

  context 'when array syntax is used' do
    it 'registers an offense for duplicate enum values' do
      inspect_source(cop, 'enum status: [:active, :archived, :active]')

      msg = 'Duplicate value `:active` found in `status` enum declaration.'
      expect(cop.messages).to eq([msg])
    end

    it 'does not register an offense for unique enum values' do
      inspect_source(cop, 'enum status: [:active, :archived]')

      expect(cop.messages).to be_empty
    end
  end

  context 'when hash syntax is used' do
    it 'registers an offense for duplicate enum values' do
      inspect_source(cop, 'enum status: { active: 0, archived: 0 }')

      msg = 'Duplicate value `0` found in `status` enum declaration.'
      expect(cop.messages).to eq([msg])
    end

    it 'does not register an offense for unique enum values' do
      inspect_source(cop, 'enum status: { active: 0, archived: 1 }')

      expect(cop.messages).to be_empty
    end
  end
end
