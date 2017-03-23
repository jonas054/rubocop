# encoding: utf-8

module RuboCop
  module Cop
    module Style
      # Checks that operators have space around them, except for **
      # which should not have surrounding space.
      class SpaceAroundOperators < Cop
        include PrecedingFollowingAlignment

        def on_pair(node)
          if node.loc.operator.is?('=>')
            _, right = *node
            check_operator(node.loc.operator, right.loc.expression)
          end
        end

        def on_if(node)
          return unless node.loc.respond_to?(:question)
          _, if_branch, else_branch = *node

          check_operator(node.loc.question, if_branch.loc.expression)
          check_operator(node.loc.colon, else_branch.loc.expression)
        end

        def on_resbody(node)
          if node.loc.assoc
            _, variable, = *node
            check_operator(node.loc.assoc, variable.loc.expression)
          end
        end

        def on_send(node)
          if node.loc.operator # aref assignment, attribute assignment
            on_special_asgn(node)
          elsif !unary_operation?(node) && !called_with_dot?(node)
            op = node.loc.selector
            if operator?(op)
              _, _, right, = *node
              check_operator(node.loc.selector, right.loc.expression)
            end
          end
        end

        def on_binary(node)
          _, right, = *node
          return if right.nil?
          check_operator(node.loc.operator, right.loc.expression)
        end

        def on_special_asgn(node)
          return unless node.loc.operator
          _, _, right, = *node
          check_operator(node.loc.operator, right.loc.expression)
        end

        alias on_or       on_binary
        alias on_and      on_binary
        alias on_lvasgn   on_binary
        alias on_masgn    on_binary
        alias on_casgn    on_special_asgn
        alias on_ivasgn   on_binary
        alias on_cvasgn   on_binary
        alias on_gvasgn   on_binary
        alias on_class    on_binary
        alias on_or_asgn  on_binary
        alias on_and_asgn on_binary
        alias on_op_asgn  on_special_asgn

        private

        def operator?(range)
          range.source !~ /^\[|\w/
        end

        def unary_operation?(node)
          whole = node.loc.expression
          selector = node.loc.selector
          return unless selector
          operator?(selector) && whole.begin_pos == selector.begin_pos
        end

        def called_with_dot?(node)
          node.loc.dot
        end

        def check_operator(op, right_operand)
          with_space = range_with_surrounding_space(op)
          return if with_space.source.start_with?("\n")

          if op.is?('**')
            unless with_space.is?('**')
              add_offense(with_space, op,
                          'Space around operator `**` detected.')
            end
          elsif with_space.source !~ /^\s.*\s$/
            add_offense(with_space, op, 'Surrounding space missing for ' \
                                        "operator `#{op.source}`.")
          elsif excess_leading_space?(op, with_space)
            add_offense(with_space, op, "Operator `#{op.source}` should be " \
                                        'surrounded with a single space.')
          elsif excess_trailing_space?(right_operand, with_space)
            add_offense(with_space, op, "Operator `#{op.source}` should be " \
                                        'surrounded with a single space.')
          end
        end

        def excess_leading_space?(op, with_space)
          with_space.source =~ /^  / &&
            (!allow_for_alignment? || !aligned_with_operator?(op))
        end

        def excess_trailing_space?(right_operand, with_space)
          with_space.source =~ /  $/ &&
            (!allow_for_alignment? || !aligned_with_something?(right_operand))
        end

        def autocorrect(range)
          lambda do |corrector|
            case range.source
            when /\*\*/
              corrector.replace(range, '**')
            else
              corrector.replace(range, " #{range.source.strip} ")
            end
          end
        end
      end
    end
  end
end
