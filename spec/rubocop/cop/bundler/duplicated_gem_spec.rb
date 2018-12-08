# frozen_string_literal: true

# rubocop:disable Layout/CommentIndentation

RSpec.describe RuboCop::Cop::Bundler::DuplicatedGem, :config do
  subject(:cop) { described_class.new(config) }

  let(:cop_config) { { 'Include' => ['**/Gemfile'] } }

  context 'when investigating Ruby files' do
    it 'does not register any offenses' do
      expect_no_offenses do
        # cop will not read these contents
        gem('rubocop')
        gem('rubocop')
      end
    end
  end

  context 'when investigating Gemfiles' do
    context 'and the file is empty' do
      it 'does not register any offenses' do
        expect_no_offenses('', 'Gemfile')
      end
    end

    context 'and no duplicate gems are present' do
      it 'does not register any offenses' do
        expect_no_offenses(nil, 'Gemfile') do
          gem 'rubocop'
          gem 'flog'
        end
      end
    end

    context 'and a gem is duplicated in default group' do
      it 'registers an offense' do
        expect_offense(nil, 'Gemfile') do
          source 'https://rubygems.org'
          gem 'rubocop'
          gem 'rubocop'
        # ^^^^^^^^^^^^^ Gem `rubocop` requirements already given on line 2 of the Gemfile.
        end
      end
    end

    context 'and a duplicated gem is in a git/path/group/platforms block' do
      it 'registers an offense' do
        expect_offense(nil, 'Gemfile') do
          gem 'rubocop'
          group :development do
            gem 'rubocop', path: '/path/to/gem'
          # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Gem `rubocop` requirements already given on line 1 of the Gemfile.
          end
        end
      end
    end
  end
end

# rubocop:enable Layout/CommentIndentation
