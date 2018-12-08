# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Style::StringMethods, :config do
  subject(:cop) { described_class.new(config) }

  let(:cop_config) { { 'intern' => 'to_sym' } }

  it 'registers an offense' do
    expect_offense(<<-RUBY.strip_indent)
      'something'.intern
                  ^^^^^^ Prefer `to_sym` over `intern`.
    RUBY
    expect_correction { 'something'.to_sym }
  end
end
