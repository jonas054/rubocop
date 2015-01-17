# encoding: utf-8

require 'parser/current'
require 'rainbow'
# Rainbow 2.0 does not load the monkey-patch for String by default.
require 'rainbow/ext/string' unless String.method_defined?(:color)

require 'English'
require 'set'
require 'ast/sexp'
require 'powerpack/enumerable/drop_last'
require 'powerpack/hash/symbolize_keys'
require 'powerpack/string/blank'
require 'powerpack/string/strip_indent'

require 'rubocop/version'

require 'rubocop/path_util'
require 'rubocop/string_util'

require 'rubocop/cop/util'
require 'rubocop/cop/offense'
require 'rubocop/cop/ignored_node'
require 'rubocop/cop/cop'
require 'rubocop/cop/commissioner'
require 'rubocop/cop/corrector'
require 'rubocop/cop/force'
require 'rubocop/cop/team'
require 'rubocop/cop/severity'

require 'rubocop/cop/variable_force'
require 'rubocop/cop/variable_force/locatable'
require 'rubocop/cop/variable_force/variable'
require 'rubocop/cop/variable_force/assignment'
require 'rubocop/cop/variable_force/reference'
require 'rubocop/cop/variable_force/scope'
require 'rubocop/cop/variable_force/variable_table'

require 'rubocop/cop/mixin/access_modifier_node'
require 'rubocop/cop/mixin/annotation_comment'
require 'rubocop/cop/mixin/array_syntax'
require 'rubocop/cop/mixin/autocorrect_alignment'
require 'rubocop/cop/mixin/autocorrect_unless_changing_ast'
require 'rubocop/cop/mixin/check_assignment'
require 'rubocop/cop/mixin/configurable_max'
require 'rubocop/cop/mixin/code_length'
require 'rubocop/cop/mixin/configurable_enforced_style'
require 'rubocop/cop/mixin/configurable_naming'
require 'rubocop/cop/mixin/empty_lines_around_body'
require 'rubocop/cop/mixin/end_keyword_alignment'
require 'rubocop/cop/mixin/if_node'
require 'rubocop/cop/mixin/negative_conditional'
require 'rubocop/cop/mixin/on_method_def'
require 'rubocop/cop/mixin/method_complexity'
require 'rubocop/cop/mixin/on_normal_if_unless'
require 'rubocop/cop/mixin/parser_diagnostic'
require 'rubocop/cop/mixin/percent_literal'
require 'rubocop/cop/mixin/safe_assignment'
require 'rubocop/cop/mixin/surrounding_space'
require 'rubocop/cop/mixin/space_inside'
require 'rubocop/cop/mixin/space_after_punctuation'
require 'rubocop/cop/mixin/space_before_punctuation'
require 'rubocop/cop/mixin/statement_modifier'
require 'rubocop/cop/mixin/string_help'
require 'rubocop/cop/mixin/string_literals_help'
require 'rubocop/cop/mixin/unused_argument'

require 'rubocop/cop/lint/ambiguous_operator'
require 'rubocop/cop/lint/ambiguous_regexp_literal'
require 'rubocop/cop/lint/assignment_in_condition'
require 'rubocop/cop/lint/block_alignment'
require 'rubocop/cop/lint/condition_position'
require 'rubocop/cop/lint/debugger'
require 'rubocop/cop/lint/def_end_alignment'
require 'rubocop/cop/lint/deprecated_class_methods'
require 'rubocop/cop/lint/duplicate_methods'
require 'rubocop/cop/lint/else_layout'
require 'rubocop/cop/lint/empty_ensure'
require 'rubocop/cop/lint/empty_interpolation'
require 'rubocop/cop/lint/end_alignment'
require 'rubocop/cop/lint/end_in_method'
require 'rubocop/cop/lint/ensure_return'
require 'rubocop/cop/lint/eval'
require 'rubocop/cop/lint/handle_exceptions'
require 'rubocop/cop/lint/invalid_character_literal'
require 'rubocop/cop/lint/literal_in_condition'
require 'rubocop/cop/lint/literal_in_interpolation'
require 'rubocop/cop/lint/loop'
require 'rubocop/cop/lint/parentheses_as_grouped_expression'
require 'rubocop/cop/lint/require_parentheses'
require 'rubocop/cop/lint/rescue_exception'
require 'rubocop/cop/lint/shadowing_outer_local_variable'
require 'rubocop/cop/lint/space_before_first_arg'
require 'rubocop/cop/lint/string_conversion_in_interpolation'
require 'rubocop/cop/lint/syntax'
require 'rubocop/cop/lint/underscore_prefixed_variable_name'
require 'rubocop/cop/lint/unreachable_code'
require 'rubocop/cop/lint/unused_block_argument'
require 'rubocop/cop/lint/unused_method_argument'
require 'rubocop/cop/lint/useless_access_modifier'
require 'rubocop/cop/lint/useless_assignment'
require 'rubocop/cop/lint/useless_comparison'
require 'rubocop/cop/lint/useless_else_without_rescue'
require 'rubocop/cop/lint/useless_setter_call'
require 'rubocop/cop/lint/void'

require 'rubocop/cop/metrics/block_nesting'
require 'rubocop/cop/metrics/class_length'
require 'rubocop/cop/metrics/cyclomatic_complexity'
require 'rubocop/cop/metrics/abc_size'
require 'rubocop/cop/metrics/line_length'
require 'rubocop/cop/metrics/method_length'
require 'rubocop/cop/metrics/parameter_lists'
require 'rubocop/cop/metrics/perceived_complexity'

require 'rubocop/cop/style/access_modifier_indentation'
require 'rubocop/cop/style/accessor_method_name'
require 'rubocop/cop/style/alias'
require 'rubocop/cop/style/align_array'
require 'rubocop/cop/style/align_hash'
require 'rubocop/cop/style/align_parameters'
require 'rubocop/cop/style/and_or'
require 'rubocop/cop/style/array_join'
require 'rubocop/cop/style/ascii_comments'
require 'rubocop/cop/style/ascii_identifiers'
require 'rubocop/cop/style/attr'
require 'rubocop/cop/style/bare_percent_literals'
require 'rubocop/cop/style/begin_block'
require 'rubocop/cop/style/block_comments'
require 'rubocop/cop/style/block_end_newline'
require 'rubocop/cop/style/blocks'
require 'rubocop/cop/style/braces_around_hash_parameters'
require 'rubocop/cop/style/case_equality'
require 'rubocop/cop/style/case_indentation'
require 'rubocop/cop/style/character_literal'
require 'rubocop/cop/style/class_and_module_camel_case'
require 'rubocop/cop/style/class_and_module_children'
require 'rubocop/cop/style/class_check'
require 'rubocop/cop/style/class_methods'
require 'rubocop/cop/style/class_vars'
require 'rubocop/cop/style/collection_methods'
require 'rubocop/cop/style/colon_method_call'
require 'rubocop/cop/style/comment_annotation'
require 'rubocop/cop/style/comment_indentation'
require 'rubocop/cop/style/constant_name'
require 'rubocop/cop/style/def_with_parentheses'
require 'rubocop/cop/style/deprecated_hash_methods'
require 'rubocop/cop/style/documentation'
require 'rubocop/cop/style/dot_position'
require 'rubocop/cop/style/double_negation'
require 'rubocop/cop/style/each_with_object'
require 'rubocop/cop/style/else_alignment'
require 'rubocop/cop/style/empty_else'
require 'rubocop/cop/style/empty_line_between_defs'
require 'rubocop/cop/style/empty_lines'
require 'rubocop/cop/style/empty_lines_around_access_modifier'
require 'rubocop/cop/style/empty_lines_around_block_body'
require 'rubocop/cop/style/empty_lines_around_class_body'
require 'rubocop/cop/style/empty_lines_around_method_body'
require 'rubocop/cop/style/empty_lines_around_module_body'
require 'rubocop/cop/style/empty_literal'
require 'rubocop/cop/style/encoding'
require 'rubocop/cop/style/end_block'
require 'rubocop/cop/style/end_of_line'
require 'rubocop/cop/style/even_odd'
require 'rubocop/cop/style/extra_spacing'
require 'rubocop/cop/style/file_name'
require 'rubocop/cop/style/flip_flop'
require 'rubocop/cop/style/for'
require 'rubocop/cop/style/format_string'
require 'rubocop/cop/style/global_vars'
require 'rubocop/cop/style/guard_clause'
require 'rubocop/cop/style/hash_syntax'
require 'rubocop/cop/style/if_unless_modifier'
require 'rubocop/cop/style/if_with_semicolon'
require 'rubocop/cop/style/indent_array'
require 'rubocop/cop/style/indent_hash'
require 'rubocop/cop/style/indentation_consistency'
require 'rubocop/cop/style/indentation_width'
require 'rubocop/cop/style/infinite_loop'
require 'rubocop/cop/style/inline_comment'
require 'rubocop/cop/style/lambda'
require 'rubocop/cop/style/lambda_call'
require 'rubocop/cop/style/leading_comment_space'
require 'rubocop/cop/style/line_end_concatenation'
require 'rubocop/cop/style/method_call_parentheses'
require 'rubocop/cop/style/method_called_on_do_end_block'
require 'rubocop/cop/style/method_def_parentheses'
require 'rubocop/cop/style/method_name'
require 'rubocop/cop/style/module_function'
require 'rubocop/cop/style/multiline_block_chain'
require 'rubocop/cop/style/multiline_block_layout'
require 'rubocop/cop/style/multiline_if_then'
require 'rubocop/cop/style/multiline_operation_indentation'
require 'rubocop/cop/style/multiline_ternary_operator'
require 'rubocop/cop/style/negated_if'
require 'rubocop/cop/style/negated_while'
require 'rubocop/cop/style/nested_ternary_operator'
require 'rubocop/cop/style/next'
require 'rubocop/cop/style/nil_comparison'
require 'rubocop/cop/style/non_nil_check'
require 'rubocop/cop/style/not'
require 'rubocop/cop/style/numeric_literals'
require 'rubocop/cop/style/one_line_conditional'
require 'rubocop/cop/style/op_method'
require 'rubocop/cop/style/parentheses_around_condition'
require 'rubocop/cop/style/percent_literal_delimiters'
require 'rubocop/cop/style/percent_q_literals'
require 'rubocop/cop/style/perl_backrefs'
require 'rubocop/cop/style/predicate_name'
require 'rubocop/cop/style/proc'
require 'rubocop/cop/style/raise_args'
require 'rubocop/cop/style/redundant_begin'
require 'rubocop/cop/style/redundant_exception'
require 'rubocop/cop/style/redundant_return'
require 'rubocop/cop/style/redundant_self'
require 'rubocop/cop/style/regexp_literal'
require 'rubocop/cop/style/rescue_modifier'
require 'rubocop/cop/style/self_assignment'
require 'rubocop/cop/style/semicolon'
require 'rubocop/cop/style/signal_exception'
require 'rubocop/cop/style/single_line_block_params'
require 'rubocop/cop/style/single_line_methods'
require 'rubocop/cop/style/single_space_before_first_arg'
require 'rubocop/cop/style/space_after_colon'
require 'rubocop/cop/style/space_after_comma'
require 'rubocop/cop/style/space_after_control_keyword'
require 'rubocop/cop/style/space_after_method_name'
require 'rubocop/cop/style/space_after_not'
require 'rubocop/cop/style/space_after_semicolon'
require 'rubocop/cop/style/space_around_equals_in_parameter_default'
require 'rubocop/cop/style/space_around_operators'
require 'rubocop/cop/style/space_before_block_braces'
require 'rubocop/cop/style/space_before_comma'
require 'rubocop/cop/style/space_before_comment'
require 'rubocop/cop/style/space_before_modifier_keyword'
require 'rubocop/cop/style/space_before_semicolon'
require 'rubocop/cop/style/space_inside_block_braces'
require 'rubocop/cop/style/space_inside_brackets'
require 'rubocop/cop/style/space_inside_hash_literal_braces'
require 'rubocop/cop/style/space_inside_parens'
require 'rubocop/cop/style/space_inside_range_literal'
require 'rubocop/cop/style/special_global_vars'
require 'rubocop/cop/style/string_literals'
require 'rubocop/cop/style/string_literals_in_interpolation'
require 'rubocop/cop/style/struct_inheritance'
require 'rubocop/cop/style/symbol_array'
require 'rubocop/cop/style/symbol_proc'
require 'rubocop/cop/style/tab'
require 'rubocop/cop/style/trailing_blank_lines'
require 'rubocop/cop/style/trailing_comma'
require 'rubocop/cop/style/trailing_whitespace'
require 'rubocop/cop/style/trivial_accessors'
require 'rubocop/cop/style/unless_else'
require 'rubocop/cop/style/unneeded_capital_w'
require 'rubocop/cop/style/unneeded_percent_q'
require 'rubocop/cop/style/unneeded_percent_x'
require 'rubocop/cop/style/variable_interpolation'
require 'rubocop/cop/style/variable_name'
require 'rubocop/cop/style/when_then'
require 'rubocop/cop/style/while_until_do'
require 'rubocop/cop/style/while_until_modifier'
require 'rubocop/cop/style/word_array'

require 'rubocop/cop/rails/action_filter'
require 'rubocop/cop/rails/default_scope'
require 'rubocop/cop/rails/delegate'
require 'rubocop/cop/rails/has_and_belongs_to_many'
require 'rubocop/cop/rails/output'
require 'rubocop/cop/rails/read_write_attribute'
require 'rubocop/cop/rails/scope_args'
require 'rubocop/cop/rails/validation'

require 'rubocop/formatter/base_formatter'
require 'rubocop/formatter/simple_text_formatter'
require 'rubocop/formatter/disabled_lines_formatter'
require 'rubocop/formatter/disabled_config_formatter'
require 'rubocop/formatter/emacs_style_formatter'
require 'rubocop/formatter/clang_style_formatter'
require 'rubocop/formatter/progress_formatter'
require 'rubocop/formatter/fuubar_style_formatter'
require 'rubocop/formatter/json_formatter'
require 'rubocop/formatter/html_formatter'
require 'rubocop/formatter/file_list_formatter'
require 'rubocop/formatter/offense_count_formatter'
require 'rubocop/formatter/formatter_set'

require 'rubocop/config'
require 'rubocop/config_loader'
require 'rubocop/config_store'
require 'rubocop/target_finder'
require 'rubocop/token'
require 'rubocop/comment_config'
require 'rubocop/processed_source'
require 'rubocop/runner'
require 'rubocop/cli'
require 'rubocop/options'
