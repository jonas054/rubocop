# frozen_string_literal: true

# rubocop:disable InternalAffairs/NodeDestructuring
# rubocop:disable Layout/CommentIndentation, Lint/UselessAssignment

RSpec.describe RuboCop::Cop::InternalAffairs::NodeDestructuring do
  subject(:cop) { described_class.new }

  context 'when destructuring using `node.children`' do
    it 'registers an offense when receiver is named `node`' do
      expect_offense do
        lhs, rhs = node.children
      # ^^^^^^^^^^^^^^^^^^^^^^^^ Use the methods provided with the node extensions or destructure the node using `*`.
      end
    end

    it 'registers an offense when receiver is named `send_node`' do
      expect_offense do
        lhs, rhs = send_node.children
      # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use the methods provided with the node extensions or destructure the node using `*`.
      end
    end
  end

  it 'does not register an offense for a predicate node type check' do
    expect_no_offenses { lhs, rhs = *node }
  end

  it 'does not register an offense when receiver is named `array`' do
    expect_no_offenses { lhs, rhs = array.children }
  end
end

# rubocop:enable InternalAffairs/NodeDestructuring
# rubocop:enable Layout/CommentIndentation, Lint/UselessAssignment
