# frozen_string_literal: true

# rubocop:disable Style/ClassCheck

RSpec.describe RuboCop::Cop::Style::ClassCheck, :config do
  subject(:cop) { described_class.new(config) }

  context 'when enforced style is is_a?' do
    let(:cop_config) { { 'EnforcedStyle' => 'is_a?' } }

    it 'registers an offense for kind_of?' do
      expect_offense do
        x.kind_of? y
        # ^^^^^^^^ Prefer `Object#is_a?` over `Object#kind_of?`.
      end
      expect_correction { x.is_a? y }
    end
  end

  context 'when enforced style is kind_of?' do
    let(:cop_config) { { 'EnforcedStyle' => 'kind_of?' } }

    it 'registers an offense for is_a?' do
      expect_offense do
        x.is_a? y
        # ^^^^^ Prefer `Object#kind_of?` over `Object#is_a?`.
      end
      expect_correction { x.kind_of? y }
    end
  end
end

# rubocop:enable Style/ClassCheck
