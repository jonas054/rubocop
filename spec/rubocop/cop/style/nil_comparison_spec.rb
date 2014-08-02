# encoding: utf-8

require 'spec_helper'

describe RuboCop::Cop::Style::NilComparison do
  subject(:cop) { described_class.new }

  context 'when inspecting `== nil`' do
    describe 'highlights' do
      it do
        registers_offense '|x == nil
                           |  ^^'
      end
    end
  end

  context 'when inspecting `=== nil`' do
    describe 'highlights' do
      it do
        registers_offense '|x === nil
                           |  ^^^'
      end
    end
  end

  context 'when autocorrecting `== nil`' do
    describe 'the replacement' do
      it do
        autocorrects(from: 'x == nil',
                     to:   'x.nil?')
      end
    end
  end

  context 'when autocorrecting `=== nil`' do
    describe 'the replacement' do
      it do
        autocorrects(from: 'x === nil',
                     to:   'x.nil?')
      end
    end
  end
end
