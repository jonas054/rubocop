# encoding: utf-8
# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::Rails::UniqBeforePluck do
  let(:corrected) { 'Model.uniq.pluck(:id)' }
  subject(:cop) { described_class.new }

  shared_examples_for 'UniqBeforePluck cop' do |source|
    it 'finds and corrects use of uniq after pluck' do
      inspect_source(cop, source)
      expect(cop.messages).to eq([described_class::MSG])
      expect(cop.highlights).to eq(['uniq'])
      expect(autocorrect_source(cop, source)).to eq(corrected)
    end
  end

  it_behaves_like 'UniqBeforePluck cop',
                  'Model.pluck(:id).uniq'

  it_behaves_like 'UniqBeforePluck cop',
                  ['Model.pluck(:id)', '  .uniq']

  it_behaves_like 'UniqBeforePluck cop',
                  ['Model.pluck(:id).', '  uniq']

  it 'ignores use of uniq before pluck' do
    source = 'Model.where(foo: 1).uniq.pluck(:something)'
    inspect_source(cop, source)
    expect(cop.messages).to be_empty
    expect(cop.highlights).to be_empty
    expect(cop.offenses).to be_empty
    expect(autocorrect_source(cop, source)).to eq(source)
  end

  it 'ignores the use of uniq without a receiver' do
    source = 'uniq.something'
    inspect_source(cop, source)
    expect(cop.offenses).to be_empty
  end
end
