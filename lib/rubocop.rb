# frozen_string_literal: true

require 'parser'
require 'rainbow'

require 'English'
require 'set'
require 'powerpack/array/butfirst'
require 'powerpack/enumerable/drop_last'
require 'powerpack/hash/symbolize_keys'
require 'powerpack/string/blank'
require 'powerpack/string/strip_indent'
require 'unicode/display_width'

require 'rubocop/version'

require 'rubocop/path_util'
require 'rubocop/string_util'
require 'rubocop/name_similarity'
require 'rubocop/node_pattern'
require 'rubocop/string_interpreter'
require 'rubocop/ast_node/sexp'
require 'rubocop/ast_node'
require 'rubocop/ast_node/builder'
require 'rubocop/ast_node/traversal'
require 'rubocop/error'
require 'rubocop/warning'

require 'rubocop/cop/util'
require 'rubocop/cop/offense'
require 'rubocop/cop/message_annotator'
require 'rubocop/cop/ignored_node'
require 'rubocop/cop/autocorrect_logic'
require 'rubocop/cop/cop'
require 'rubocop/cop/commissioner'
require 'rubocop/cop/corrector'
require 'rubocop/cop/force'
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
require 'rubocop/cop/mixin/array_hash_indentation'
require 'rubocop/cop/mixin/array_syntax'
require 'rubocop/cop/mixin/autocorrect_alignment'
require 'rubocop/cop/mixin/check_assignment'
require 'rubocop/cop/mixin/configurable_max'
require 'rubocop/cop/mixin/code_length' # relies on configurable_max
require 'rubocop/cop/mixin/classish_length' # relies on code_length
require 'rubocop/cop/mixin/configurable_enforced_style'
require 'rubocop/cop/mixin/configurable_naming'
require 'rubocop/cop/mixin/configurable_numbering'
require 'rubocop/cop/mixin/def_node'
require 'rubocop/cop/mixin/documentation_comment'
require 'rubocop/cop/mixin/empty_lines_around_body'
require 'rubocop/cop/mixin/end_keyword_alignment'
require 'rubocop/cop/mixin/first_element_line_break'
require 'rubocop/cop/mixin/frozen_string_literal'
require 'rubocop/cop/mixin/hash_node'
require 'rubocop/cop/mixin/if_node'
require 'rubocop/cop/mixin/integer_node'
require 'rubocop/cop/mixin/on_method_def'
require 'rubocop/cop/mixin/match_range'
require 'rubocop/cop/mixin/method_complexity' # relies on on_method_def
require 'rubocop/cop/mixin/method_preference'
require 'rubocop/cop/mixin/min_body_length'
require 'rubocop/cop/mixin/multiline_expression_indentation'
require 'rubocop/cop/mixin/multiline_literal_brace_layout'
require 'rubocop/cop/mixin/negative_conditional'
require 'rubocop/cop/mixin/on_normal_if_unless'
require 'rubocop/cop/mixin/parentheses'
require 'rubocop/cop/mixin/parser_diagnostic'
require 'rubocop/cop/mixin/percent_literal'
require 'rubocop/cop/mixin/preceding_following_alignment'
require 'rubocop/cop/mixin/safe_assignment'
require 'rubocop/cop/mixin/safe_mode'
require 'rubocop/cop/mixin/space_after_punctuation'
require 'rubocop/cop/mixin/space_before_punctuation'
require 'rubocop/cop/mixin/surrounding_space'
require 'rubocop/cop/mixin/space_inside' # relies on surrounding_space
require 'rubocop/cop/mixin/statement_modifier'
require 'rubocop/cop/mixin/string_help'
require 'rubocop/cop/mixin/string_literals_help'
require 'rubocop/cop/mixin/too_many_lines'
require 'rubocop/cop/mixin/trailing_comma'
require 'rubocop/cop/mixin/unused_argument'

require 'rubocop/cop/bundler/duplicated_gem'
require 'rubocop/cop/bundler/ordered_gems'

require 'rubocop/cop/lint/ambiguous_operator'
require 'rubocop/cop/lint/ambiguous_regexp_literal'
require 'rubocop/cop/lint/assignment_in_condition'
require 'rubocop/cop/lint/block_alignment'
require 'rubocop/cop/lint/circular_argument_reference'
require 'rubocop/cop/lint/condition_position'
require 'rubocop/cop/lint/debugger'
require 'rubocop/cop/lint/def_end_alignment'
require 'rubocop/cop/lint/deprecated_class_methods'
require 'rubocop/cop/lint/duplicate_case_condition'
require 'rubocop/cop/lint/duplicate_methods'
require 'rubocop/cop/lint/duplicated_key'
require 'rubocop/cop/lint/each_with_object_argument'
require 'rubocop/cop/lint/else_layout'
require 'rubocop/cop/lint/empty_ensure'
require 'rubocop/cop/lint/empty_expression'
require 'rubocop/cop/lint/empty_interpolation'
require 'rubocop/cop/lint/empty_when'
require 'rubocop/cop/lint/end_alignment'
require 'rubocop/cop/lint/end_in_method'
require 'rubocop/cop/lint/ensure_return'
require 'rubocop/cop/lint/float_out_of_range'
require 'rubocop/cop/lint/format_parameter_mismatch'
require 'rubocop/cop/lint/handle_exceptions'
require 'rubocop/cop/lint/implicit_string_concatenation'
require 'rubocop/cop/lint/inherit_exception'
require 'rubocop/cop/lint/ineffective_access_modifier'
require 'rubocop/cop/lint/invalid_character_literal'
require 'rubocop/cop/lint/literal_in_condition'
require 'rubocop/cop/lint/literal_in_interpolation'
require 'rubocop/cop/lint/loop'
require 'rubocop/cop/lint/multiple_compare'
require 'rubocop/cop/lint/nested_method_definition'
require 'rubocop/cop/lint/next_without_accumulator'
require 'rubocop/cop/lint/non_local_exit_from_iterator'
require 'rubocop/cop/lint/parentheses_as_grouped_expression'
require 'rubocop/cop/lint/percent_string_array'
require 'rubocop/cop/lint/percent_symbol_array'
require 'rubocop/cop/lint/rand_one'
require 'rubocop/cop/lint/require_parentheses'
require 'rubocop/cop/lint/rescue_exception'
require 'rubocop/cop/lint/safe_navigation_chain'
require 'rubocop/cop/lint/shadowed_exception'
require 'rubocop/cop/lint/shadowing_outer_local_variable'
require 'rubocop/cop/lint/string_conversion_in_interpolation'
require 'rubocop/cop/lint/syntax'
require 'rubocop/cop/lint/underscore_prefixed_variable_name'
require 'rubocop/cop/lint/unified_integer'
require 'rubocop/cop/lint/unneeded_disable'
require 'rubocop/cop/lint/unneeded_splat_expansion'
require 'rubocop/cop/lint/unreachable_code'
require 'rubocop/cop/lint/unused_block_argument'
require 'rubocop/cop/lint/unused_method_argument'
require 'rubocop/cop/lint/useless_access_modifier'
require 'rubocop/cop/lint/useless_assignment'
require 'rubocop/cop/lint/useless_comparison'
require 'rubocop/cop/lint/useless_else_without_rescue'
require 'rubocop/cop/lint/useless_setter_call'
require 'rubocop/cop/lint/void'

require 'rubocop/cop/metrics/cyclomatic_complexity'
require 'rubocop/cop/metrics/abc_size' # relies on cyclomatic_complexity
require 'rubocop/cop/metrics/block_length'
require 'rubocop/cop/metrics/block_nesting'
require 'rubocop/cop/metrics/class_length'
require 'rubocop/cop/metrics/line_length'
require 'rubocop/cop/metrics/method_length'
require 'rubocop/cop/metrics/module_length'
require 'rubocop/cop/metrics/parameter_lists'
require 'rubocop/cop/metrics/perceived_complexity'

require 'rubocop/cop/performance/case_when_splat'
require 'rubocop/cop/performance/casecmp'
require 'rubocop/cop/performance/count'
require 'rubocop/cop/performance/detect'
require 'rubocop/cop/performance/double_start_end_with'
require 'rubocop/cop/performance/end_with'
require 'rubocop/cop/performance/fixed_size'
require 'rubocop/cop/performance/flat_map'
require 'rubocop/cop/performance/hash_each_methods'
require 'rubocop/cop/performance/lstrip_rstrip'
require 'rubocop/cop/performance/range_include'
require 'rubocop/cop/performance/redundant_block_call'
require 'rubocop/cop/performance/redundant_match'
require 'rubocop/cop/performance/redundant_merge'
require 'rubocop/cop/performance/redundant_sort_by'
require 'rubocop/cop/performance/regexp_match'
require 'rubocop/cop/performance/reverse_each'
require 'rubocop/cop/performance/sample'
require 'rubocop/cop/performance/size'
require 'rubocop/cop/performance/compare_with_block'
require 'rubocop/cop/performance/start_with'
require 'rubocop/cop/performance/string_replacement'
require 'rubocop/cop/performance/times_map'

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
require 'rubocop/cop/style/auto_resource_cleanup'
require 'rubocop/cop/style/bare_percent_literals'
require 'rubocop/cop/style/begin_block'
require 'rubocop/cop/style/block_comments'
require 'rubocop/cop/style/block_delimiters'
require 'rubocop/cop/style/block_end_newline'
require 'rubocop/cop/style/braces_around_hash_parameters'
require 'rubocop/cop/style/case_equality'
require 'rubocop/cop/style/case_indentation'
require 'rubocop/cop/style/character_literal'
require 'rubocop/cop/style/class_and_module_camel_case'
require 'rubocop/cop/style/class_and_module_children'
require 'rubocop/cop/style/class_check'
require 'rubocop/cop/style/class_methods'
require 'rubocop/cop/style/class_vars'
require 'rubocop/cop/style/closing_parenthesis_indentation'
require 'rubocop/cop/style/collection_methods'
require 'rubocop/cop/style/colon_method_call'
require 'rubocop/cop/style/command_literal'
require 'rubocop/cop/style/comment_annotation'
require 'rubocop/cop/style/comment_indentation'
require 'rubocop/cop/style/conditional_assignment'
require 'rubocop/cop/style/constant_name'
require 'rubocop/cop/style/copyright'
require 'rubocop/cop/style/def_with_parentheses'
require 'rubocop/cop/style/preferred_hash_methods'
require 'rubocop/cop/style/documentation_method'
require 'rubocop/cop/style/documentation'
require 'rubocop/cop/style/dot_position'
require 'rubocop/cop/style/double_negation'
require 'rubocop/cop/style/each_for_simple_loop'
require 'rubocop/cop/style/each_with_object'
require 'rubocop/cop/style/else_alignment'
require 'rubocop/cop/style/empty_case_condition'
require 'rubocop/cop/style/empty_else'
require 'rubocop/cop/style/empty_line_between_defs'
require 'rubocop/cop/style/empty_lines'
require 'rubocop/cop/style/empty_lines_around_access_modifier'
require 'rubocop/cop/style/empty_lines_around_block_body'
require 'rubocop/cop/style/empty_lines_around_class_body'
require 'rubocop/cop/style/empty_lines_around_method_body'
require 'rubocop/cop/style/empty_lines_around_module_body'
require 'rubocop/cop/style/empty_literal'
require 'rubocop/cop/style/empty_method'
require 'rubocop/cop/style/encoding'
require 'rubocop/cop/style/end_block'
require 'rubocop/cop/style/end_of_line'
require 'rubocop/cop/style/even_odd'
require 'rubocop/cop/style/extra_spacing'
require 'rubocop/cop/style/file_name'
require 'rubocop/cop/style/first_array_element_line_break'
require 'rubocop/cop/style/first_hash_element_line_break'
require 'rubocop/cop/style/first_method_argument_line_break'
require 'rubocop/cop/style/first_method_parameter_line_break'
require 'rubocop/cop/style/first_parameter_indentation'
require 'rubocop/cop/style/flip_flop'
require 'rubocop/cop/style/for'
require 'rubocop/cop/style/format_string'
require 'rubocop/cop/style/frozen_string_literal_comment'
require 'rubocop/cop/style/global_vars'
require 'rubocop/cop/style/guard_clause'
require 'rubocop/cop/style/hash_syntax'
require 'rubocop/cop/style/identical_conditional_branches'
require 'rubocop/cop/style/if_inside_else'
require 'rubocop/cop/style/if_unless_modifier'
require 'rubocop/cop/style/if_unless_modifier_of_if_unless'
require 'rubocop/cop/style/if_with_semicolon'
require 'rubocop/cop/style/implicit_runtime_error'
require 'rubocop/cop/style/indent_array'
require 'rubocop/cop/style/indent_assignment'
require 'rubocop/cop/style/indent_hash'
require 'rubocop/cop/style/indentation_consistency'
require 'rubocop/cop/style/indentation_width'
require 'rubocop/cop/style/infinite_loop'
require 'rubocop/cop/style/initial_indentation'
require 'rubocop/cop/style/inline_comment'
require 'rubocop/cop/style/lambda'
require 'rubocop/cop/style/lambda_call'
require 'rubocop/cop/style/leading_comment_space'
require 'rubocop/cop/style/line_end_concatenation'
require 'rubocop/cop/style/method_call_parentheses'
require 'rubocop/cop/style/method_called_on_do_end_block'
require 'rubocop/cop/style/method_def_parentheses'
require 'rubocop/cop/style/method_name'
require 'rubocop/cop/style/method_missing'
require 'rubocop/cop/style/missing_else'
require 'rubocop/cop/style/module_function'
require 'rubocop/cop/style/multiline_array_brace_layout'
require 'rubocop/cop/style/multiline_assignment_layout'
require 'rubocop/cop/style/multiline_block_chain'
require 'rubocop/cop/style/multiline_block_layout'
require 'rubocop/cop/style/multiline_hash_brace_layout'
require 'rubocop/cop/style/multiline_if_then'
require 'rubocop/cop/style/multiline_if_modifier'
require 'rubocop/cop/style/multiline_memoization'
require 'rubocop/cop/style/multiline_method_call_brace_layout'
require 'rubocop/cop/style/multiline_method_call_indentation'
require 'rubocop/cop/style/multiline_method_definition_brace_layout'
require 'rubocop/cop/style/multiline_operation_indentation'
require 'rubocop/cop/style/multiline_ternary_operator'
require 'rubocop/cop/style/mutable_constant'
require 'rubocop/cop/style/negated_if'
require 'rubocop/cop/style/negated_while'
require 'rubocop/cop/style/nested_modifier'
require 'rubocop/cop/style/nested_parenthesized_calls'
require 'rubocop/cop/style/nested_ternary_operator'
require 'rubocop/cop/style/next'
require 'rubocop/cop/style/nil_comparison'
require 'rubocop/cop/style/non_nil_check'
require 'rubocop/cop/style/not'
require 'rubocop/cop/style/numeric_literals'
require 'rubocop/cop/style/numeric_literal_prefix'
require 'rubocop/cop/style/numeric_predicate'
require 'rubocop/cop/style/one_line_conditional'
require 'rubocop/cop/style/op_method'
require 'rubocop/cop/style/option_hash'
require 'rubocop/cop/style/optional_arguments'
require 'rubocop/cop/style/parallel_assignment'
require 'rubocop/cop/style/parentheses_around_condition'
require 'rubocop/cop/style/percent_literal_delimiters'
require 'rubocop/cop/style/percent_q_literals'
require 'rubocop/cop/style/perl_backrefs'
require 'rubocop/cop/style/predicate_name'
require 'rubocop/cop/style/proc'
require 'rubocop/cop/style/raise_args'
require 'rubocop/cop/style/redundant_begin'
require 'rubocop/cop/style/redundant_exception'
require 'rubocop/cop/style/redundant_freeze'
require 'rubocop/cop/style/redundant_parentheses'
require 'rubocop/cop/style/redundant_return'
require 'rubocop/cop/style/redundant_self'
require 'rubocop/cop/style/regexp_literal'
require 'rubocop/cop/style/rescue_ensure_alignment'
require 'rubocop/cop/style/rescue_modifier'
require 'rubocop/cop/style/safe_navigation'
require 'rubocop/cop/style/self_assignment'
require 'rubocop/cop/style/semicolon'
require 'rubocop/cop/style/send'
require 'rubocop/cop/style/signal_exception'
require 'rubocop/cop/style/single_line_block_params'
require 'rubocop/cop/style/single_line_methods'
require 'rubocop/cop/style/space_after_colon'
require 'rubocop/cop/style/space_after_comma'
require 'rubocop/cop/style/space_after_method_name'
require 'rubocop/cop/style/space_after_not'
require 'rubocop/cop/style/space_after_semicolon'
require 'rubocop/cop/style/space_around_block_parameters'
require 'rubocop/cop/style/space_around_equals_in_parameter_default'
require 'rubocop/cop/style/space_around_keyword'
require 'rubocop/cop/style/space_around_operators'
require 'rubocop/cop/style/space_before_block_braces'
require 'rubocop/cop/style/space_before_comma'
require 'rubocop/cop/style/space_before_comment'
require 'rubocop/cop/style/space_before_first_arg'
require 'rubocop/cop/style/space_before_semicolon'
require 'rubocop/cop/style/space_in_lambda_literal'
require 'rubocop/cop/style/space_inside_array_percent_literal'
require 'rubocop/cop/style/space_inside_block_braces'
require 'rubocop/cop/style/space_inside_brackets'
require 'rubocop/cop/style/space_inside_hash_literal_braces'
require 'rubocop/cop/style/space_inside_parens'
require 'rubocop/cop/style/space_inside_percent_literal_delimiters'
require 'rubocop/cop/style/space_inside_range_literal'
require 'rubocop/cop/style/space_inside_string_interpolation'
require 'rubocop/cop/style/special_global_vars'
require 'rubocop/cop/style/stabby_lambda_parentheses'
require 'rubocop/cop/style/string_literals'
require 'rubocop/cop/style/string_literals_in_interpolation'
require 'rubocop/cop/style/string_methods'
require 'rubocop/cop/style/struct_inheritance'
require 'rubocop/cop/style/symbol_array'
require 'rubocop/cop/style/symbol_literal'
require 'rubocop/cop/style/symbol_proc'
require 'rubocop/cop/style/tab'
require 'rubocop/cop/style/ternary_parentheses'
require 'rubocop/cop/style/trailing_blank_lines'
require 'rubocop/cop/style/trailing_comma_in_arguments'
require 'rubocop/cop/style/trailing_comma_in_literal'
require 'rubocop/cop/style/trailing_underscore_variable'
require 'rubocop/cop/style/trailing_whitespace'
require 'rubocop/cop/style/trivial_accessors'
require 'rubocop/cop/style/unless_else'
require 'rubocop/cop/style/unneeded_capital_w'
require 'rubocop/cop/style/unneeded_interpolation'
require 'rubocop/cop/style/unneeded_percent_q'
require 'rubocop/cop/style/variable_interpolation'
require 'rubocop/cop/style/variable_name'
require 'rubocop/cop/style/variable_number'
require 'rubocop/cop/style/when_then'
require 'rubocop/cop/style/while_until_do'
require 'rubocop/cop/style/while_until_modifier'
require 'rubocop/cop/style/word_array'
require 'rubocop/cop/style/zero_length_predicate'

require 'rubocop/cop/rails/action_filter'
require 'rubocop/cop/rails/date'
require 'rubocop/cop/rails/dynamic_find_by'
require 'rubocop/cop/rails/delegate'
require 'rubocop/cop/rails/delegate_allow_blank'
require 'rubocop/cop/rails/enum_uniqueness'
require 'rubocop/cop/rails/exit'
require 'rubocop/cop/rails/file_path'
require 'rubocop/cop/rails/find_by'
require 'rubocop/cop/rails/find_each'
require 'rubocop/cop/rails/has_and_belongs_to_many'
require 'rubocop/cop/rails/http_positional_arguments'
require 'rubocop/cop/rails/not_null_column'
require 'rubocop/cop/rails/output_safety'
require 'rubocop/cop/rails/output'
require 'rubocop/cop/rails/pluralization_grammar'
require 'rubocop/cop/rails/read_write_attribute'
require 'rubocop/cop/rails/request_referer'
require 'rubocop/cop/rails/safe_navigation'
require 'rubocop/cop/rails/save_bang'
require 'rubocop/cop/rails/scope_args'
require 'rubocop/cop/rails/time_zone'
require 'rubocop/cop/rails/uniq_before_pluck'
require 'rubocop/cop/rails/validation'

require 'rubocop/cop/security/eval'
require 'rubocop/cop/security/json_load'
require 'rubocop/cop/security/marshal_load'
require 'rubocop/cop/security/yaml_load'

require 'rubocop/cop/team'

require 'rubocop/formatter/base_formatter'
require 'rubocop/formatter/simple_text_formatter'
require 'rubocop/formatter/clang_style_formatter' # relies on simple text
require 'rubocop/formatter/disabled_config_formatter'
require 'rubocop/formatter/disabled_lines_formatter'
require 'rubocop/formatter/emacs_style_formatter'
require 'rubocop/formatter/file_list_formatter'
require 'rubocop/formatter/fuubar_style_formatter'
require 'rubocop/formatter/html_formatter'
require 'rubocop/formatter/json_formatter'
require 'rubocop/formatter/offense_count_formatter'
require 'rubocop/formatter/progress_formatter'
require 'rubocop/formatter/worst_offenders_formatter'

require 'rubocop/formatter/formatter_set'

require 'rubocop/cached_data'
require 'rubocop/config'
require 'rubocop/config_loader_resolver'
require 'rubocop/config_loader'
require 'rubocop/config_store'
require 'rubocop/target_finder'
require 'rubocop/token'
require 'rubocop/comment_config'
require 'rubocop/processed_source'
require 'rubocop/result_cache'
require 'rubocop/runner'
require 'rubocop/cli'
require 'rubocop/options'
require 'rubocop/remote_config'
