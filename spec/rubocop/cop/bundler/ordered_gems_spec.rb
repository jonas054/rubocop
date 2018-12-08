# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bundler::OrderedGems, :config do
  subject(:cop) { described_class.new(config) }

  let(:cop_config) do
    {
      'TreatCommentsAsGroupSeparators' => treat_comments_as_group_separators,
      'Include' => nil
    }
  end
  let(:treat_comments_as_group_separators) { false }

  context 'When gems are alphabetically sorted' do
    it 'does not register any offenses' do
      expect_no_offenses do
        gem 'rspec'
        gem 'rubocop'
      end
    end
  end

  context 'when a gem is referenced from a variable' do
    it 'ignores the line' do
      expect_no_offenses do
        gem 'rspec'
        gem ENV['env_key_undefined'] if ENV.key?('env_key_undefined')
        gem 'rubocop'
      end
    end

    it 'resets the sorting to a new block' do
      expect_no_offenses do
        gem 'rubocop'
        gem ENV['env_key_undefined'] if ENV.key?('env_key_undefined')
        gem 'ast'
      end
    end
  end

  context 'When gems are not alphabetically sorted' do
    it 'registers an offense' do
      expect_offense do
        gem 'rubocop'
        gem 'rspec'
        ########### Gems should be sorted in an alphabetical order within their section of the Gemfile. Gem `rspec` should appear before `rubocop`.
      end
      expect_correction do
        gem 'rspec'
        gem 'rubocop'
      end
    end
  end

  context 'When each individual group of line is sorted' do
    it 'does not register any offenses' do
      expect_no_offenses do
        gem 'rspec'
        gem 'rubocop'

        gem 'hello'
        gem 'world'
      end
    end
  end

  context 'When a gem declaration takes several lines' do
    it 'registers an offense' do
      expect_offense do
        gem 'rubocop',
            '0.1.1'
        gem 'rspec'
        ########### Gems should be sorted in an alphabetical order within their section of the Gemfile. Gem `rspec` should appear before `rubocop`.
      end
      expect_correction do
        gem 'rspec'
        gem 'rubocop',
            '0.1.1'
      end
    end
  end

  context 'When the gemfile is empty' do
    it 'does not register any offenses' do
      expect_no_offenses('# Gemfile')
    end
  end

  context 'When each individual group of line is not sorted' do
    let(:source) { <<-RUBY.strip_indent }
        gem "d"
        gem "b"
        gem "e"
        gem "a"
        gem "c"

        gem "h"
        gem "g"
        gem "j"
        gem "f"
        gem "i"
    RUBY

    it 'registers some offenses' do
      expect_offense do
        gem 'd'
        gem 'b'
        ####### Gems should be sorted in an alphabetical order within their section of the Gemfile. Gem `b` should appear before `d`.
        gem 'e'
        gem 'a'
        ####### Gems should be sorted in an alphabetical order within their section of the Gemfile. Gem `a` should appear before `e`.
        gem 'c'

        gem 'h'
        gem 'g'
        ####### Gems should be sorted in an alphabetical order within their section of the Gemfile. Gem `g` should appear before `h`.
        gem 'j'
        gem 'f'
        ####### Gems should be sorted in an alphabetical order within their section of the Gemfile. Gem `f` should appear before `j`.
        gem 'i'
      end
    end

    it 'autocorrects' do
      new_source = autocorrect_source_with_loop(source)
      expect(new_source).to eq(<<-RUBY.strip_indent)
        gem "a"
        gem "b"
        gem "c"
        gem "d"
        gem "e"

        gem "f"
        gem "g"
        gem "h"
        gem "i"
        gem "j"
      RUBY
    end
  end

  context 'When gem groups is separated by multiline comment' do
    let(:source) { <<-RUBY.strip_indent }
      # For code quality
      gem 'rubocop'
      # For
      # test
      gem 'rspec'
    RUBY

    context 'with TreatCommentsAsGroupSeparators: true' do
      let(:treat_comments_as_group_separators) { true }

      it 'accepts' do
        expect_no_offenses(source)
      end
    end

    context 'with TreatCommentsAsGroupSeparators: false' do
      it 'registers an offense' do
        expect_offense do
          # For code quality
          gem 'rubocop'
          # For
          # test
          gem 'rspec'
          ########### Gems should be sorted in an alphabetical order within their section of the Gemfile. Gem `rspec` should appear before `rubocop`.
        end
      end

      it 'autocorrects' do
        new_source = autocorrect_source_with_loop(source)
        expect(new_source).to eq(<<-RUBY.strip_indent)
          # For
          # test
          gem 'rspec'
          # For code quality
          gem 'rubocop'
        RUBY
      end
    end
  end

  context 'When gems have an inline comment, and not sorted' do
    let(:source) { <<-RUBY.strip_indent }
      gem 'rubocop' # For code quality
      gem 'pry'
      gem 'rspec'   # For test
    RUBY

    it 'registers an offense' do
      expect_offense do
        gem 'rubocop' # For code quality
        gem 'pry'
        ######### Gems should be sorted in an alphabetical order within their section of the Gemfile. Gem `pry` should appear before `rubocop`.
        gem 'rspec' # For test
      end
    end

    it 'autocorrects' do
      new_source = autocorrect_source_with_loop(source)
      expect(new_source).to eq(<<-RUBY.strip_indent)
        gem 'pry'
        gem 'rspec'   # For test
        gem 'rubocop' # For code quality
      RUBY
    end
  end

  context 'When gems are asciibetically sorted' do
    it 'does not register an offense' do
      expect_no_offenses do
        gem 'paper_trail'
        gem 'paperclip'
      end
    end
  end

  context 'When a gem that starts with a capital letter is sorted' do
    it 'does not register an offense' do
      expect_no_offenses do
        gem 'a'
        gem 'Z'
      end
    end
  end

  context 'When a gem that starts with a capital letter is not sorted' do
    let(:source) { <<-RUBY.strip_indent }
      gem 'Z'
      gem 'a'
    RUBY

    it 'registers an offense' do
      expect_offense do
        gem 'Z'
        gem 'a'
        ####### Gems should be sorted in an alphabetical order within their section of the Gemfile. Gem `a` should appear before `Z`.
      end
    end

    it 'autocorrects' do
      new_source = autocorrect_source_with_loop(source)
      expect(new_source).to eq(<<-RUBY.strip_indent)
        gem 'a'
        gem 'Z'
      RUBY
    end
  end

  context 'When there are duplicated gems in group' do
    let(:source) { <<-RUBY.strip_indent }
      gem 'a'

      group :development do
        gem 'b'
        gem 'c'
        gem 'b'
      end
    RUBY

    it 'registers an offense' do
      expect_offense do
        gem 'a'

        group :development do
          gem 'b'
          gem 'c'
          gem 'b'
          ####### Gems should be sorted in an alphabetical order within their section of the Gemfile. Gem `b` should appear before `c`.
        end
      end
    end

    it 'autocorrects' do
      new_source = autocorrect_source_with_loop(source)
      expect(new_source).to eq(<<-RUBY.strip_indent)
        gem 'a'

        group :development do
          gem 'b'
          gem 'b'
          gem 'c'
        end
      RUBY
    end
  end
end
