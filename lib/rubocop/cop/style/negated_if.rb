# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # Checks for uses of if with a negated condition. Only ifs
      # without else are considered.
      class NegatedIf < Cop
        include NegativeConditional

        MSG = 'Favor `%s` over `%s` for negative conditions.'.freeze

        def on_if(node)
          return if node.elsif?

          check_negative_conditional(node)
        end

        def message(node)
          if node.if?
            format(MSG, 'unless', 'if')
          else
            format(MSG, 'if', 'unless')
          end
        end

        private

        def autocorrect(node)
          lambda do |corrector|
            condition = node.condition
            # look inside parentheses around the condition
            condition = condition.children.first while condition.begin_type?
            # unwrap the negated portion of the condition (a send node)
            pos_condition, _method, = *condition
            corrector.replace(
              node.loc.keyword,
              node.if? ? 'unless' : 'if'
            )
            corrector.replace(condition.source_range, pos_condition.source)
          end
        end
      end
    end
  end
end
