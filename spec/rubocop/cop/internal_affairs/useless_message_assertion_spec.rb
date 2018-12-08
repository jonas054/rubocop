# frozen_string_literal: true

# rubocop:disable InternalAffairs/UselessMessageAssertion

RSpec.describe RuboCop::Cop::InternalAffairs::UselessMessageAssertion do
  subject(:cop) { described_class.new }

  it 'registers an offense for specs that assert using the MSG' do
    expect_offense(nil, 'example_spec.rb') do
      it 'uses described_class::MSG to specify the expected message' do
        inspect_source(cop, 'foo')
        expect(cop.messages).to eq([described_class::MSG])
        #                           ^^^^^^^^^^^^^^^^^^^^ Do not specify cop behavior using `described_class::MSG`.
      end
    end
  end

  it 'registers an offense for described_class::MSG in let' do
    expect_offense(nil, 'example_spec.rb') do
      let(:msg) { described_class::MSG }
      #           ^^^^^^^^^^^^^^^^^^^^ Do not specify cop behavior using `described_class::MSG`.
    end
  end

  it 'does not register an offense for an assertion about the message' do
    expect_no_offenses(nil, 'example_spec.rb') do
      it 'has a good message' do
        expect(described_class::MSG).to eq('Good message.')
      end
    end
  end
end

# rubocop:enable InternalAffairs/UselessMessageAssertion
