# frozen_string_literal: true

# rubocop:disable InternalAffairs/RedundantMessageArgument
# rubocop:disable InternalAffairs/RedundantLocationArgument
# rubocop:disable Layout/CommentIndentation

RSpec.describe RuboCop::Cop::InternalAffairs::RedundantMessageArgument do
  subject(:cop) { described_class.new }

  context 'when `MSG` is passed' do
    it 'registers an offense' do
      expect_offense do
        add_offense(node, message: MSG)
        #                 ^^^^^^^^^^^^ Redundant message argument to `#add_offense`.
      end
    end

    it 'auto-corrects' do
      new_source = autocorrect_source('add_offense(node, message: MSG)')

      expect(new_source).to eq('add_offense(node)')
    end
  end

  it 'does not register an offense when formatted `MSG` is passed' do
    expect_no_offenses(<<-RUBY.strip_indent, 'example_cop.rb')
      add_offense(node, location: :expression, message: MSG % foo)
    RUBY
  end

  context 'when `#message` is passed' do
    it 'registers an offense' do
      expect_offense do
        add_offense(node, location: :expression, message: message)
        #                                        ^^^^^^^^^^^^^^^^ Redundant message argument to `#add_offense`.
      end
    end

    it 'auto-corrects' do
      new_source = autocorrect_source(<<-RUBY.strip_indent)
        add_offense(
          node,
          location: :expression,
          message: message,
          severity: :error
        )
      RUBY

      expect(new_source).to eq(<<-RUBY.strip_indent)
        add_offense(
          node,
          location: :expression,
          severity: :error
        )
      RUBY
    end
  end

  context 'when `#message` with offending node is passed' do
    context 'when message is the only keyword argument' do
      it 'registers an offense' do
        expect_offense do
          add_offense(node, message: message(node))
          #                 ^^^^^^^^^^^^^^^^^^^^^^ Redundant message argument to `#add_offense`.
        end
        expect_correction { add_offense(node) }
      end
    end

    context 'when there are others keyword arguments' do
      it 'registers an offense' do
        expect_offense do
          add_offense(node,
                      location: :selector,
                      message: message(node),
          #           ^^^^^^^^^^^^^^^^^^^^^^ Redundant message argument to `#add_offense`.
                      severity: :fatal)
        end
        expect_correction do
          add_offense(node,
                      location: :selector,
                      severity: :fatal)
        end
      end
    end
  end

  it 'does not register an offense when `#message` with another node ' \
     ' is passed' do
    expect_no_offenses(<<-RUBY.strip_indent, 'example_cop.rb')
      add_offense(node, message: message(other_node))
    RUBY
  end
end

# rubocop:enable InternalAffairs/RedundantLocationArgument
# rubocop:enable InternalAffairs/RedundantMessageArgument
# rubocop:enable Layout/CommentIndentation
