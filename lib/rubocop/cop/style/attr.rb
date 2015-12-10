# encoding: utf-8

module RuboCop
  module Cop
    module Style
      # This cop checks for uses of Module#attr.
      class Attr < Cop
        def on_send(node)
          return unless command?(:attr, node)
          _receiver, _method_name, *args = *node
          msg = "Do not use `attr`. Use `#{replacement_method(node)}` instead."

          add_offense(node, :selector, msg) if args.any?
        end

        def autocorrect(node)
          _receiver, _method_name, attr_name, setter = *node
          node_expr = node.loc.expression
          attr_expr = attr_name.loc.expression

          if setter && (setter.true_type? || setter.false_type?)
            remove = Parser::Source::Range.new(node_expr.source_buffer,
                                               attr_expr.end_pos,
                                               node_expr.end_pos)
          end

          lambda do |corrector|
            corrector.replace(node.loc.selector, replacement_method(node))
            corrector.replace(remove, '') if remove
          end
        end

        private

        def replacement_method(node)
          _receiver, _method_name, _attr_name, setter = *node
          if setter && (setter.true_type? || setter.false_type?)
            setter.true_type? ? 'attr_accessor' : 'attr_reader'
          else
            'attr_reader'
          end
        end
      end
    end
  end
end
