# encoding: utf-8

require 'spec_helper'

describe RuboCop::Cop::Style::Next, :config do
  subject(:cop) { described_class.new(config) }
  let(:cop_config) { { 'MinBodyLength' => 1 } }

  shared_examples 'iterators' do |condition|
    it "registers an offense for #{condition} inside of downto" do
      inspect_source(cop, ['3.downto(1) do',
                           "  #{condition} o == 1",
                           '    puts o',
                           '  end',
                           'end'])

      expect(cop.messages).to eq(['Use `next` to skip iteration.'])
      expect(cop.highlights).to eq(["#{condition} o == 1"])
    end

    it "registers an offense for #{condition} inside of each" do
      inspect_source(cop, ['[].each do |o|',
                           "  #{condition} o == 1",
                           '    puts o',
                           '  end',
                           'end'])

      expect(cop.messages).to eq(['Use `next` to skip iteration.'])
      expect(cop.highlights).to eq(["#{condition} o == 1"])
    end

    it "registers an offense for #{condition} inside of each_with_object" do
      inspect_source(cop, ['[].each_with_object({}) do |o, a|',
                           "  #{condition} o == 1",
                           '    a[o] = {}',
                           '  end',
                           'end'])

      expect(cop.messages).to eq(['Use `next` to skip iteration.'])
      expect(cop.highlights).to eq(["#{condition} o == 1"])
    end

    it "registers an offense for #{condition}  inside of for" do
      inspect_source(cop, ['for o in 1..3 do',
                           "  #{condition} o == 1",
                           '    puts o',
                           '  end',
                           'end'])

      expect(cop.messages).to eq(['Use `next` to skip iteration.'])
      expect(cop.highlights).to eq(["#{condition} o == 1"])
    end

    it "registers an offense for #{condition} inside of loop" do
      inspect_source(cop, ['loop do',
                           "  #{condition} o == 1",
                           '    puts o',
                           '  end',
                           'end'])

      expect(cop.messages).to eq(['Use `next` to skip iteration.'])
      expect(cop.highlights).to eq(["#{condition} o == 1"])
    end

    it "registers an offense for #{condition} inside of map" do
      inspect_source(cop, ['loop do',
                           '  {}.map do |k, v|',
                           "    #{condition} v == 1",
                           '      puts k',
                           '    end',
                           '  end',
                           'end'])

      expect(cop.messages).to eq(['Use `next` to skip iteration.'])
      expect(cop.highlights).to eq(["#{condition} v == 1"])
    end

    it "registers an offense for #{condition} inside of times" do
      inspect_source(cop, ['loop do',
                           '  3.times do |o|',
                           "    #{condition} o == 1",
                           '      puts o',
                           '    end',
                           '  end',
                           'end'])

      expect(cop.messages).to eq(['Use `next` to skip iteration.'])
      expect(cop.highlights).to eq(["#{condition} o == 1"])
    end

    it "registers an offense for #{condition} inside of nested iterators" do
      inspect_source(cop, ['loop do',
                           '  until false',
                           "    #{condition} o == 1",
                           '      puts o',
                           '    end',
                           '  end',
                           'end'])

      expect(cop.messages).to eq(['Use `next` to skip iteration.'])
      expect(cop.highlights).to eq(["#{condition} o == 1"])
    end

    it "registers an offense for #{condition} inside of nested iterators" do
      inspect_source(cop, ['loop do',
                           '  while true',
                           "    #{condition} o == 1",
                           '      puts o',
                           '    end',
                           '  end',
                           'end'])

      expect(cop.messages).to eq(['Use `next` to skip iteration.'])
      expect(cop.highlights).to eq(["#{condition} o == 1"])
    end

    it 'registers an offense for a condition at the end of an iterator ' \
       'when there is more in the iterator than the condition' do
      inspect_source(cop, ['[].each do |o|',
                           '  puts o',
                           "  #{condition} o == 1",
                           '    puts o',
                           '  end',
                           'end'])

      expect(cop.messages).to eq(['Use `next` to skip iteration.'])
      expect(cop.highlights).to eq(["#{condition} o == 1"])
    end

    it 'allows loops with conditional break' do
      inspect_source(cop, ['loop do',
                           "  puts ''",
                           "  break #{condition} o == 1",
                           'end'])

      expect(cop.offenses).to be_empty
    end

    it 'allows loops with conditional return' do
      inspect_source(cop, ['loop do',
                           "  puts ''",
                           "  return #{condition} o == 1",
                           'end'])

      expect(cop.offenses).to be_empty
    end

    it "allows loops with #{condition} being the entire body with else" do
      inspect_source(cop, ['[].each do |o|',
                           "  #{condition} o == 1",
                           '    puts o',
                           '  else',
                           "    puts 'no'",
                           '  end',
                           'end'])

      expect(cop.offenses).to be_empty
    end

    it "allows loops with #{condition} with else at the end" do
      inspect_source(cop, ['[].each do |o|',
                           '  puts o',
                           "  #{condition} o == 1",
                           '    puts o',
                           '  else',
                           "    puts 'no'",
                           '  end',
                           'end'])

      expect(cop.offenses).to be_empty
    end

    it "reports an offense for #{condition} whose body has 3 lines" do
      inspect_source(cop, ['arr.each do |e|',
                           "  #{condition} something",
                           '    work',
                           '    work',
                           '    work',
                           '  end',
                           'end'])

      expect(cop.offenses.size).to eq(1)
      expect(cop.highlights).to eq(["#{condition} something"])
    end

    context 'EnforcedStyle: skip_modifier_ifs' do
      let(:cop_config) do
        { 'EnforcedStyle' => 'skip_modifier_ifs' }
      end

      it "allows modifier #{condition}" do
        inspect_source(cop, ['[].each do |o|',
                             "  puts o #{condition} o == 1",
                             'end'])

        expect(cop.offenses).to be_empty
      end
    end

    context 'EnforcedStyle: always' do
      let(:cop_config) do
        { 'EnforcedStyle' => 'always' }
      end

      it "registers an offense for modifier #{condition}" do
        inspect_source(cop, ['[].each do |o|',
                             "  puts o #{condition} o == 1",
                             'end'])

        expect(cop.messages).to eq(['Use `next` to skip iteration.'])
        expect(cop.highlights).to eq(["puts o #{condition} o == 1"])
      end
    end
  end

  it_behaves_like 'iterators', 'if'
  it_behaves_like 'iterators', 'unless'

  it 'allows empty blocks' do
    inspect_source(cop, ['[].each do',
                         'end',
                         '[].each { }'])

    expect(cop.offenses).to be_empty
  end

  it 'allows loops with conditions at the end with ternary op' do
    inspect_source(cop, ['[].each do |o|',
                         '  o == x ? y : z',
                         'end'])

    expect(cop.offenses).to be_empty
  end

  it 'allows super nodes' do
    # https://github.com/bbatsov/rubocop/issues/1115
    inspect_source(cop, ['def foo',
                         '  super(a, a) { a }',
                         'end'])

    expect(cop.offenses).to be_empty
  end

  it 'does not blow up on empty body until block' do
    inspect_source(cop, 'until sup; end')

    expect(cop.offenses).to be_empty
  end

  it 'does not blow up on empty body while block' do
    inspect_source(cop, 'while sup; end')

    expect(cop.offenses).to be_empty
  end

  it 'does not blow up on empty body for block' do
    inspect_source(cop, 'for x in y; end')

    expect(cop.offenses).to be_empty
  end

  it 'does not crash with an empty body branch' do
    inspect_source(cop, ['loop do',
                         '  if true',
                         '  end',
                         'end'])
    expect(cop.offenses).to be_empty
  end

  context 'MinBodyLength: 3' do
    let(:cop_config) do
      { 'MinBodyLength' => 3 }
    end

    it 'accepts if whose body has 1 line' do
      inspect_source(cop, ['arr.each do |e|',
                           '  if something',
                           '    work',
                           '  end',
                           'end'])

      expect(cop.offenses).to be_empty
    end
  end

  context 'Invalid MinBodyLength' do
    let(:cop_config) do
      { 'MinBodyLength' => -2 }
    end

    it 'fails with an error' do
      source = ['loop do',
                '  if o == 1',
                '    puts o',
                '  end',
                'end']

      expect { inspect_source(cop, source) }
        .to raise_error('MinBodyLength needs to be a positive integer!')
    end
  end
end
