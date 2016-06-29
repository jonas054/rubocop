# encoding: utf-8
# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::Lint::ShadowedException do
  subject(:cop) { described_class.new }

  context 'modifier rescue' do
    it 'accepts rescue in its modifier form' do
      inspect_source(cop, 'foo rescue nil')

      expect(cop.offenses).to be_empty
    end
  end

  context 'single rescue' do
    it 'accepts an empty rescue' do
      inspect_source(cop, ['begin',
                           '  something',
                           'rescue',
                           '  handle_exception',
                           'end'])

      expect(cop.offenses).to be_empty
    end

    it 'accepts rescuing a single exception' do
      inspect_source(cop, ['begin',
                           '  something',
                           'rescue Exception',
                           '  handle_exception',
                           'end'])

      expect(cop.offenses).to be_empty
    end

    it 'accepts rescuing a single custom exception' do
      inspect_source(cop, ['begin',
                           '  something',
                           'rescue NonStandardException',
                           '  handle_exception',
                           'end'])

      expect(cop.offenses).to be_empty
    end

    it 'accepts rescuing a custom exception and a standard exception' do
      inspect_source(cop, ['begin',
                           '  something',
                           'rescue Error, NonStandardException',
                           '  handle_exception',
                           'end'])

      expect(cop.offenses).to be_empty
    end

    it 'accepts rescuing a single exception that is assigned to a variable' do
      inspect_source(cop, ['begin',
                           '  something',
                           'rescue Exception => e',
                           '  handle_exception(e)',
                           'end'])

      expect(cop.offenses).to be_empty
    end

    it 'accepts rescuing a single exception that has an ensure' do
      inspect_source(cop, ['begin',
                           '  something',
                           'rescue Exception',
                           '  handle_exception',
                           'ensure',
                           '  everything_is_ok',
                           'end'])

      expect(cop.offenses).to be_empty
    end

    it 'accepts rescuing a single exception that has an else' do
      inspect_source(cop, ['begin',
                           '  something',
                           'rescue Exception',
                           '  handle_exception',
                           'else',
                           '  handle_non_exception',
                           'end'])

      expect(cop.offenses).to be_empty
    end

    it 'accepts rescuing a multiple exceptions that are not ancestors that ' \
       'have an else' do
      inspect_source(cop, ['begin',
                           '  something',
                           'rescue NoMethodError, ZeroDivisionError',
                           '  handle_exception',
                           'else',
                           '  handle_non_exception',
                           'end'])

      expect(cop.offenses).to be_empty
    end

    it 'registers an offense when rescuing multiple levels of exceptions ' \
       'in the same rescue' do
      inspect_source(cop, ['begin',
                           '  something',
                           'rescue StandardError, Exception',
                           '  foo',
                           'end'])

      expect(cop.messages).to eq(['Do not shadow rescued Exceptions'])
      expect(cop.highlights).to eq(['rescue StandardError, Exception'])
    end

    it 'accepts splat arguments passed to rescue' do
      inspect_source(cop, ['begin',
                           '  a',
                           'rescue *FOO',
                           '  b',
                           'end'])

      expect(cop.offenses).to be_empty
    end

    it 'accepts rescuing nil' do
      inspect_source(cop, ['begin',
                           '  a',
                           'rescue nil',
                           '  b',
                           'end'])

      expect(cop.offenses).to be_empty
    end

    it 'accepts rescuing nil and another exception' do
      inspect_source(cop, ['begin',
                           '  a',
                           'rescue nil, Exception',
                           '  b',
                           'end'])

      expect(cop.offenses).to be_empty
    end

    it 'registers an offense when rescuing nil multiple exceptions of ' \
       'different levels' do
      inspect_source(cop, ['begin',
                           '  a',
                           'rescue nil, StandardError, Exception',
                           '  b',
                           'end'])

      expect(cop.messages).to eq(['Do not shadow rescued Exceptions'])
      expect(cop.highlights).to eq(['rescue nil, StandardError, Exception'])
    end
  end

  context 'multiple rescues' do
    it 'registers an offense when a higher level exception is rescued before' \
       ' a lower level exception' do
      inspect_source(cop, ['begin',
                           '  something',
                           'rescue Exception',
                           '  handle_exception',
                           'rescue StandardError',
                           '  handle_standard_error',
                           'end'])

      expect(cop.messages).to eq(['Do not shadow rescued Exceptions'])
      expect(cop.highlights).to eq([['rescue Exception',
                                     '  handle_exception',
                                     'rescue StandardError'].join("\n")])
    end

    it 'registers an offense when a higher level exception is rescued before ' \
       'a lower level exception when there are multiple exceptions ' \
       'rescued in a group' do
      inspect_source(cop, ['begin',
                           '  something',
                           'rescue Exception',
                           '  handle_exception',
                           'rescue NoMethodError, ZeroDivisionError',
                           '  handle_standard_error',
                           'end'])

      expect(cop.messages).to eq(['Do not shadow rescued Exceptions'])
      expect(cop.highlights).to eq([['rescue Exception',
                                     '  handle_exception',
                                     'rescue NoMethodError, ZeroDivisionError']
                                     .join("\n")])
    end

    it 'registers an offense rescuing out of order exceptions when there ' \
       'is an ensure' do
      inspect_source(cop, ['begin',
                           '  something',
                           'rescue Exception',
                           '  handle_exception',
                           'rescue StandardError',
                           '  handle_standard_error',
                           'ensure',
                           '  everything_is_ok',
                           'end'])

      expect(cop.messages).to eq(['Do not shadow rescued Exceptions'])
      expect(cop.highlights).to eq([['rescue Exception',
                                     '  handle_exception',
                                     'rescue StandardError'].join("\n")])
    end

    it 'accepts rescuing exceptions in order of level' do
      inspect_source(cop, ['begin',
                           '  something',
                           'rescue StandardError',
                           '  handle_standard_error',
                           'rescue Exception',
                           '  handle_exception',
                           'end'])

      expect(cop.offenses).to be_empty
    end

    it 'accepts rescuing exceptions in order of level with multiple ' \
       'exceptions in a group' do
      inspect_source(cop, ['begin',
                           '  something',
                           'rescue NoMethodError, ZeroDivisionError',
                           '  handle_standard_error',
                           'rescue Exception',
                           '  handle_exception',
                           'end'])

      expect(cop.offenses).to be_empty
    end

    it 'accepts rescuing exceptions in order of level with multiple ' \
       'exceptions in a group with custom exceptions' do
      inspect_source(cop, ['begin',
                           '  something',
                           'rescue NonStandardError, NoMethodError',
                           '  handle_standard_error',
                           'rescue Exception',
                           '  handle_exception',
                           'end'])

      expect(cop.offenses).to be_empty
    end

    context 'splat arguments' do
      it 'accepts splat arguments passed to multiple rescues' do
        inspect_source(cop, ['begin',
                             '  a',
                             'rescue *FOO',
                             '  b',
                             'rescue *BAR',
                             '  c',
                             'end'])

        expect(cop.offenses).to be_empty
      end

      it 'registers an offense for splat arguments rescued after ' \
         'rescuing Exception' do
        inspect_source(cop, ['begin',
                             '  a',
                             'rescue Exception',
                             '  b',
                             'rescue *BAR',
                             '  c',
                             'end'])

        expect(cop.messages).to eq(['Do not shadow rescued Exceptions'])
        expect(cop.highlights).to eq([['rescue Exception',
                                       '  b',
                                       'rescue *BAR'].join("\n")])
      end
    end

    context 'exceptions from different ancestry chains' do
      it 'accepts rescuing exceptions in one order' do
        inspect_source(cop, ['begin',
                             '  a',
                             'rescue ArgumentError',
                             '  b',
                             'rescue Interrupt',
                             '  c',
                             'end'])

        expect(cop.offenses).to be_empty
      end

      it 'accepts rescuing exceptions in another order' do
        inspect_source(cop, ['begin',
                             '  a',
                             'rescue Interrupt',
                             '  b',
                             'rescue ArgumentError',
                             '  c',
                             'end'])

        expect(cop.offenses).to be_empty
      end
    end

    it 'accepts rescuing nil before another exception' do
      inspect_source(cop, ['begin',
                           '  a',
                           'rescue nil',
                           '  b',
                           'rescue',
                           '  c',
                           'end'])

      expect(cop.offenses).to be_empty
    end

    it 'accepts rescuing nil after another exception' do
      inspect_source(cop, ['begin',
                           '  a',
                           'rescue',
                           '  b',
                           'rescue nil',
                           '  c',
                           'end'])

      expect(cop.offenses).to be_empty
    end
  end
end
