# encoding: utf-8

require 'spec_helper'

describe RuboCop::Cop::Style::AccessModifierIndentation, :config do
  subject(:cop) { described_class.new(config) }

  context 'when EnforcedStyle is set to indent' do
    let(:cop_config) { { 'EnforcedStyle' => 'indent' } }

    it 'registers an offense for misaligned private' do
      registers_offense '|class Test
                         |
                         |private
                         |^^^^^^^
                         |
                         |  def test; end
                         |end'
      expect(cop.messages).to eq(['Indent access modifiers like `private`.'])
      expect(cop.config_to_allow_offenses).to eq('EnforcedStyle' => 'outdent')
    end

    it 'registers an offense for misaligned private in module' do
      registers_offense '|module Test
                         |
                         | private
                         | ^^^^^^^
                         |
                         |  def test; end
                         |end'
      expect(cop.messages).to eq(['Indent access modifiers like `private`.'])
      # Not aligned according to `indent` or `outdent` style:
      expect(cop.config_to_allow_offenses).to eq('Enabled' => false)
    end

    it 'registers an offense for correct + opposite alignment' do
      registers_offense '|module Test
                         |
                         |  public
                         |
                         |private
                         |^^^^^^^
                         |
                         |  def test; end
                         |end'
      expect(cop.messages).to eq(['Indent access modifiers like `private`.'])
      # No EnforcedStyle can allow both aligments:
      expect(cop.config_to_allow_offenses).to eq('Enabled' => false)
    end

    it 'registers an offense for opposite + correct alignment' do
      registers_offense '|module Test
                         |
                         |public
                         |^^^^^^
                         |
                         |  private
                         |
                         |  def test; end
                         |end'
      expect(cop.messages).to eq(['Indent access modifiers like `public`.'])
      # No EnforcedStyle can allow both aligments:
      expect(cop.config_to_allow_offenses).to eq('Enabled' => false)
    end

    it 'registers an offense for misaligned private in singleton class' do
      registers_offense '|class << self
                         |private
                         |^^^^^^^
                         |  def test; end
                         |end'
      expect(cop.messages).to eq(['Indent access modifiers like `private`.'])
    end

    it 'registers an offense for misaligned private in class ' \
       'defined with Class.new' do
      registers_offense '|Test = Class.new do
                         |
                         |private
                         |^^^^^^^
                         |
                         |  def test; end
                         |end'
      expect(cop.messages).to eq(['Indent access modifiers like `private`.'])
    end

    it 'accepts misaligned private in blocks that are not recognized as ' \
       'class/module definitions' do
      registers_no_offense '|Test = func do
                            |
                            |private
                            |
                            |  def test; end
                            |end'
    end

    it 'registers an offense for misaligned private in module ' \
       'defined with Module.new' do
      registers_offense '|Test = Module.new do
                         |
                         |private
                         |^^^^^^^
                         |
                         |  def test; end
                         |end'
      expect(cop.messages).to eq(['Indent access modifiers like `private`.'])
    end

    it 'registers an offense for misaligned protected' do
      registers_offense '|class Test
                         |
                         |protected
                         |^^^^^^^^^
                         |
                         |  def test; end
                         |end'
      expect(cop.messages).to eq(['Indent access modifiers like `protected`.'])
    end

    it 'accepts properly indented private' do
      registers_no_offense '|class Test
                            |
                            |  private
                            |
                            |  def test; end
                            |end'
    end

    it 'accepts properly indented protected' do
      registers_no_offense '|class Test
                            |
                            |  protected
                            |
                            |  def test; end
                            |end'
    end

    it 'accepts an empty class' do
      registers_no_offense '|class Test
                            |end'
    end

    it 'handles properly nested classes' do
      registers_offense '|class Test
                         |
                         |  class Nested
                         |
                         |  private
                         |  ^^^^^^^
                         |
                         |    def a; end
                         |  end
                         |
                         |  protected
                         |
                         |  def test; end
                         |end'
    end

    it 'auto-corrects incorrectly indented access modifiers' do
      autocorrects(from: '|class Test
                          |
                          |public
                          | private
                          |   protected
                          |
                          |  def test; end
                          |end',
                   to: '|class Test
                        |
                        |  public
                        |  private
                        |  protected
                        |
                        |  def test; end
                        |end')
    end
  end

  context 'when EnforcedStyle is set to outdent' do
    let(:cop_config) { { 'EnforcedStyle' => 'outdent' } }
    let(:indent_msg) { 'Outdent access modifiers like `private`.' }

    it 'registers offense for private indented to method depth in a class' do
      registers_offense '|class Test
                         |
                         |  private
                         |  ^^^^^^^
                         |
                         |  def test; end
                         |end'
      expect(cop.messages).to eq([indent_msg])
      expect(cop.config_to_allow_offenses).to eq('EnforcedStyle' => 'indent')
    end

    it 'registers offense for private indented to method depth in a module' do
      registers_offense '|module Test
                         |
                         |  private
                         |  ^^^^^^^
                         |
                         |  def test; end
                         |end'
    end

    it 'registers offense for private indented to method depth in singleton' \
       'class' do
      registers_offense '|class << self
                         |
                         |  private
                         |  ^^^^^^^
                         |
                         |  def test; end
                         |end'
      expect(cop.messages).to eq([indent_msg])
    end

    it 'registers offense for private indented to method depth in class ' \
       'defined with Class.new' do
      registers_offense '|Test = Class.new do
                         |
                         |  private
                         |  ^^^^^^^
                         |
                         |  def test; end
                         |end'
      expect(cop.messages).to eq([indent_msg])
    end

    it 'registers offense for private indented to method depth in module ' \
       'defined with Module.new' do
      registers_offense '|Test = Module.new do
                         |
                         |  private
                         |  ^^^^^^^
                         |
                         |  def test; end
                         |end'
      expect(cop.messages).to eq([indent_msg])
    end

    it 'accepts private indented to the containing class indent level' do
      registers_no_offense '|class Test
                            |
                            |private
                            |
                            |  def test; end
                            |end'
    end

    it 'accepts protected indented to the containing class indent level' do
      registers_no_offense '|class Test
                            |
                            |protected
                            |
                            |  def test; end
                            |end'
    end

    it 'handles properly nested classes' do
      registers_offense '|class Test
                         |
                         |  class Nested
                         |
                         |    private
                         |    ^^^^^^^
                         |
                         |    def a; end
                         |  end
                         |
                         |protected
                         |
                         |  def test; end
                         |end'
      expect(cop.messages).to eq([indent_msg])
    end

    it 'auto-corrects incorrectly indented access modifiers' do
      autocorrects(from: '|module M
                          |  class Test
                          |
                          |public
                          | private
                          |     protected
                          |
                          |    def test; end
                          |  end
                          |end',
                   to: '|module M
                        |  class Test
                        |
                        |  public
                        |  private
                        |  protected
                        |
                        |    def test; end
                        |  end
                        |end')
    end

    it 'auto-corrects private in complicated case' do
      autocorrects(from: "|class Hello
                          |  def foo
                          |    'hi'
                          |  end
                          |
                          |  def bar
                          |    Module.new do
                          |
                          |     private
                          |
                          |      def hi
                          |        'bye'
                          |      end
                          |    end
                          |  end
                          |end",
                   to: "|class Hello
                        |  def foo
                        |    'hi'
                        |  end
                        |
                        |  def bar
                        |    Module.new do
                        |
                        |    private
                        |
                        |      def hi
                        |        'bye'
                        |      end
                        |    end
                        |  end
                        |end")
    end
  end
end
