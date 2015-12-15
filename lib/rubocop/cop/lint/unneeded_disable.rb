# encoding: utf-8

module RuboCop
  module Cop
    module Lint
      # This cop detects instances of rubocop:disable comments that can be
      # removed without causing any offenses to be reported. It's implemented
      # as a cop in that it inherits from the Cop base class and calls
      # add_offense. The unusual part of its implementation is that it doesn't
      # have any on_* methods or an investigate method. This means that it
      # doesn't take part in the investigation phase when the other cops do
      # their work. Instead, it waits until it's called in a later stage of the
      # execution. The reason it can't be implemented as a normal cop is that
      # it depends on the results of all other cops to do its work.
      class UnneededDisable < Cop
        include NameSimilarity

        COP_NAME = 'Lint/UnneededDisable'

        def check(offenses, cop_disabled_line_ranges, comments)
          unneeded_cops = Hash.new { |h, k| h[k] = Set.new }
          disabled_ranges = cop_disabled_line_ranges[COP_NAME] || [0..0]

          cop_disabled_line_ranges.each do |cop, line_ranges|
            cop_offenses = offenses.select { |o| o.cop_name == cop }
            line_ranges.each do |line_range|
              comment = comments.find { |c| c.loc.line == line_range.begin }
              unneeded_cop = find_unneeded(comment, offenses, cop, cop_offenses,
                                           line_range)

              unless all_disabled?(comment)
                next if ignore_offense?(disabled_ranges, line_range)
              end

              unneeded_cops[comment].add(unneeded_cop) if unneeded_cop
            end
          end

          add_offenses(unneeded_cops)
        end

        private

        def find_unneeded(comment, offenses, cop, cop_offenses, line_range)
          if all_disabled?(comment)
            'all' if offenses.none? { |o| line_range.cover?(o.line) }
          elsif cop_offenses.none? { |o| line_range.cover?(o.line) }
            cop
          end
        end

        def all_disabled?(comment)
          comment.text =~ /rubocop:disable\s+all\b/
        end

        def ignore_offense?(disabled_ranges, line_range)
          disabled_ranges.any? do |range|
            range.cover?(line_range.min) && range.cover?(line_range.max)
          end
        end

        def directive_count(comment)
          match = comment.text.match(CommentConfig::COMMENT_DIRECTIVE_REGEXP)
          _, cops_string = match.captures
          cops_string.split(/,\s*/).size
        end

        def add_offenses(unneeded_cops)
          unneeded_cops.each do |comment, cops|
            if all_disabled?(comment) ||
               directive_count(comment) == cops.size
              range    = comment.loc.expression
              cop_list = cops.sort.map { |c| describe(c) }
              add_offense(range, range,
                          "Unnecessary disabling of #{cop_list.join(', ')}.")
            else
              cops.each do |cop|
                range = matching_range(comment.loc.expression, cop) ||
                        matching_range(comment.loc.expression,
                                       cop.split('/').last)
                unless range
                  fail "Couldn't find #{cop} in comment: #{comment.text}"
                end

                add_offense(range, range,
                            "Unnecessary disabling of #{describe(cop)}.")
              end
            end
          end
        end

        def matching_range(haystack, needle)
          if offset = (haystack.source =~ Regexp.new(Regexp.escape(needle)))
            Parser::Source::Range.new(haystack.source_buffer, offset,
                                      offset + needle.size)
          end
        end

        def describe(cop)
          if cop == 'all'
            'all cops'
          elsif all_cop_names.include?(cop)
            "`#{cop}`"
          else
            similar = find_similar_name(cop, [])
            if similar
              "`#{cop}` (did you mean `#{similar}`?)"
            else
              "`#{cop}` (unknown cop)"
            end
          end
        end

        def collect_variable_like_names(scope)
          all_cop_names.each { |name| scope << name }
        end

        def all_cop_names
          @all_cop_names ||= Cop.all.map(&:cop_name)
        end
      end
    end
  end
end
