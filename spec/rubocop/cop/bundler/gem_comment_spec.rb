# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bundler::GemComment, :config do
  subject(:cop) { described_class.new(config) }

  let(:cop_config) do
    {
      'Include' => ['**/Gemfile'],
      'Whitelist' => ['rake']
    }
  end

  context 'when investigating Ruby files' do
    it 'does not register any offenses' do
      expect_no_offenses { gem('rubocop') }
    end
  end

  context 'when investigating Gemfiles' do
    context 'and the file is empty' do
      it 'does not register any offenses' do
        expect_no_offenses('', 'Gemfile')
      end
    end

    context 'and the gem is commented' do
      it 'does not register any offenses' do
        expect_no_offenses(nil, 'Gemfile') do
          # Style-guide enforcer.
          gem 'rubocop'
        end
      end
    end

    context 'and the gem is whitelisted' do
      it 'does not register any offenses' do
        expect_no_offenses(nil, 'Gemfile') { gem 'rake' }
      end
    end

    context 'and the file contains source and group' do
      it 'does not register any offenses' do
        expect_no_offenses(nil, 'Gemfile') do
          source 'http://rubygems.org'

          # Style-guide enforcer.
          group :development do
            # ...
          end
        end
      end
    end

    context 'and a gem has no comment' do
      it 'registers an offense' do
        expect_offense(nil, 'Gemfile') do
          gem 'rubocop'
          ############# Missing gem description comment.
        end
      end
    end
  end
end
