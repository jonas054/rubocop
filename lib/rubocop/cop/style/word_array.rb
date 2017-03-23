# encoding: utf-8

module RuboCop
  module Cop
    module Style
      # This cop can check for array literals made up of word-like
      # strings, that are not using the %w() syntax.
      #
      # Alternatively, it can check for uses of the %w() syntax, in projects
      # which do not want to include that syntax.
      class WordArray < Cop
        include ArraySyntax

        PERCENT_MSG = 'Use `%w` or `%W` for an array of words.'
        ARRAY_MSG = 'Use `[]` for an array of words.'
        QUESTION_MARK_SIZE = '?'.size

        def on_array(node)
          array_elems = node.children

          if bracketed_array_of?(:str, node)
            return if complex_content?(array_elems) ||
                      comments_in_array?(node)
            style_detected(:brackets, array_elems.size)

            if style == :percent && array_elems.size >= min_size
              add_offense(node, :expression, PERCENT_MSG)
            end
          elsif node.loc.begin && node.loc.begin.source =~ /\A%[wW]/
            style_detected(:percent, array_elems.size)
            add_offense(node, :expression, ARRAY_MSG) if style == :brackets
          end
        end

        def autocorrect(node)
          if style == :percent
            @interpolated = false
            contents = autocorrect_words(node.children, node.loc.line)

            char = @interpolated ? 'W' : 'w'

            lambda do |corrector|
              corrector.replace(node.loc.expression, "%#{char}(#{contents})")
            end
          else
            words = node.children.map { |c| to_string_literal(c.children[0]) }
            lambda do |corrector|
              corrector.replace(node.loc.expression, "[#{words.join(', ')}]")
            end
          end
        end

        private

        def comments_in_array?(node)
          comments = processed_source.comments
          array_range = node.loc.expression.to_a

          comments.any? do |comment|
            !(comment.loc.expression.to_a & array_range).empty?
          end
        end

        def complex_content?(arr_sexp)
          arr_sexp.each do |s|
            source = s.source
            next if source.start_with?('?') # %W(\r \n) can replace [?\r, ?\n]

            str_content = Util.strip_quotes(source)
            return true unless str_content =~ word_regex
          end

          false
        end

        def style
          cop_config['EnforcedStyle'].to_sym
        end

        def min_size
          cop_config['MinSize']
        end

        def word_regex
          cop_config['WordRegex']
        end

        def autocorrect_words(word_nodes, base_line_number)
          previous_node_line_number = base_line_number
          word_nodes.map do |node|
            number_of_line_breaks = node.loc.line - previous_node_line_number
            line_breaks = "\n" * number_of_line_breaks
            previous_node_line_number = node.loc.line

            line_breaks + source_for(node)
          end.join(' ')
        end

        def source_for(str_node)
          if character_literal?(str_node)
            @interpolated = true
            begin_pos = str_node.loc.expression.begin_pos + QUESTION_MARK_SIZE
            end_pos = str_node.loc.expression.end_pos
          else
            begin_pos = str_node.loc.begin.end_pos
            end_pos = str_node.loc.end.begin_pos
          end
          Parser::Source::Range.new(str_node.loc.expression.source_buffer,
                                    begin_pos, end_pos).source
        end

        def character_literal?(node)
          node.loc.end.nil?
        end

        def style_detected(style, ary_size)
          cfg = config_to_allow_offenses
          return if cfg['Enabled'] == false

          @largest_brackets ||= -Float::INFINITY
          @smallest_percent ||= Float::INFINITY

          if style == :percent
            @smallest_percent = ary_size if ary_size < @smallest_percent
          else
            @largest_brackets = ary_size if ary_size > @largest_brackets
          end

          if cfg['EnforcedStyle'] == style.to_s
            # do nothing
          elsif cfg['EnforcedStyle'].nil?
            cfg['EnforcedStyle'] = style.to_s
          elsif @smallest_percent <= @largest_brackets
            self.config_to_allow_offenses = { 'Enabled' => false }
          else
            cfg['EnforcedStyle'] = 'percent'
            cfg['MinSize'] = @largest_brackets + 1
          end
        end
      end
    end
  end
end
