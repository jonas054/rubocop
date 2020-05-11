# frozen_string_literal: true

require 'fileutils'

module RuboCop
  module Formatter
    # This is a collection of formatters. A FormatterSet can hold multiple
    # formatter instances and provides transparent formatter API methods
    # which invoke same method of each formatters.
    class FormatterSet < Array
      BUILTIN_FORMATTERS_FOR_KEYS = {
        '[a]utogenconf' => AutoGenConfigFormatter,
        '[c]lang'       => ClangStyleFormatter,
        '[e]macs'       => EmacsStyleFormatter,
        '[fi]les'       => FileListFormatter,
        '[fu]ubar'      => FuubarStyleFormatter,
        '[h]tml'        => HTMLFormatter,
        '[j]son'        => JSONFormatter,
        '[ju]nit'       => JUnitFormatter,
        '[o]ffenses'    => OffenseCountFormatter,
        '[pa]cman'      => PacmanFormatter,
        '[p]rogress'    => ProgressFormatter,
        '[q]uiet'       => QuietFormatter,
        '[s]imple'      => SimpleTextFormatter,
        '[t]ap'         => TapFormatter,
        '[w]orst'       => WorstOffendersFormatter
      }.freeze

      FORMATTER_APIS = %i[started finished].freeze

      FORMATTER_APIS.each do |method_name|
        define_method(method_name) do |*args|
          each { |f| f.send(method_name, *args) }
        end
      end

      def initialize(options = {})
        @options = options # CLI options
        @hidden_offenses = {}
      end

      def file_started(file, options)
        @options = options[:cli_options]
        @config_store = options[:config_store]
        each { |f| f.file_started(file, options) }
      end

      def file_finished(file, offenses)
        offenses_to_report = without_allowed(offenses,
                                             PathUtil.smart_path(file))
        each { |f| f.file_finished(file, offenses_to_report) }
        offenses_to_report
      end

      def add_formatter(formatter_type, output_path = nil)
        if output_path
          dir_path = File.dirname(output_path)
          FileUtils.mkdir_p(dir_path) unless File.exist?(dir_path)
          output = File.open(output_path, 'w')
        else
          output = $stdout
        end

        self << formatter_class(formatter_type).new(output, @options)
      end

      def close_output_files
        each do |formatter|
          formatter.output.close if formatter.output.is_a?(File)
        end
      end

      private

      def without_allowed(offenses, path)
        config = @config_store.for(path)
        allowed = config.for_cop('AllCops')['AllowedOffenses']
        return offenses unless allowed

        config_dir = File.dirname(config.loaded_path)
        path = PathUtil.relative_path(path, config_dir)
        allowed_for_file = allowed[path]
        return offenses unless allowed_for_file

        offenses.reject do |offense|
          should_be_hidden?(offense, path, allowed_for_file)
        end
      end

      def should_be_hidden?(offense, path, allowed_for_file)
        cop_name = offense.cop_name
        return false unless allowed_for_file[cop_name]

        @hidden_offenses[path] ||= Hash.new(0)
        if @hidden_offenses[path][cop_name] >= allowed_for_file[cop_name]
          return false
        end

        @hidden_offenses[path][cop_name] += 1
        true
      end

      def formatter_class(formatter_type)
        case formatter_type
        when Class
          formatter_type
        when /\A[A-Z]/
          custom_formatter_class(formatter_type)
        else
          builtin_formatter_class(formatter_type)
        end
      end

      def builtin_formatter_class(specified_key)
        matching_keys = BUILTIN_FORMATTERS_FOR_KEYS.keys.select do |key|
          key =~ /^\[#{specified_key}\]/ || specified_key == key.delete('[]')
        end

        raise %(No formatter for "#{specified_key}") if matching_keys.empty?

        if matching_keys.size > 1
          raise %(Cannot determine formatter for "#{specified_key}")
        end

        BUILTIN_FORMATTERS_FOR_KEYS[matching_keys.first]
      end

      def custom_formatter_class(specified_class_name)
        constant_names = specified_class_name.split('::')
        constant_names.shift if constant_names.first.empty?
        constant_names.reduce(Object) do |namespace, constant_name|
          namespace.const_get(constant_name, false)
        end
      end
    end
  end
end
