# frozen_string_literal: true

# rubocop:disable InternalAffairs/NodeTypePredicate, Layout/CommentIndentation

RSpec.describe RuboCop::Cop::InternalAffairs::NodeTypePredicate do
  subject(:cop) { described_class.new }

  context 'comparison node type check' do
    it 'registers an offense and auto-corrects' do
      expect_offense do
        node.type == :send
      # ^^^^^^^^^^^^^^^^^^ Use `#send_type?` to check node type.
      end
      expect_correction { node.send_type? }
    end
  end

  it 'does not register an offense for a predicate node type check' do
    expect_no_offenses { node.send_type? }
  end
end

# rubocop:enable InternalAffairs/NodeTypePredicate, Layout/CommentIndentation
