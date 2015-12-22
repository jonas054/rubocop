# encoding: utf-8

require 'spec_helper'

describe RuboCop::Cop::Rails::ActionFilter, :config do
  subject(:cop) { described_class.new(config) }
  let(:cop_config) { { 'Include' => nil } }

  describe '::FILTER_METHODS' do
    it 'contains all of the filter methods' do
      expect(described_class::FILTER_METHODS).to eq([
                                                      :after_filter,
                                                      :append_after_filter,
                                                      :append_around_filter,
                                                      :append_before_filter,
                                                      :around_filter,
                                                      :before_filter,
                                                      :prepend_after_filter,
                                                      :prepend_around_filter,
                                                      :prepend_before_filter,
                                                      :skip_after_filter,
                                                      :skip_around_filter,
                                                      :skip_before_filter,
                                                      :skip_filter
                                                    ])
    end
  end

  describe '::ACTION_METHODS' do
    it 'contains all of the action methods' do
      expect(described_class::ACTION_METHODS).to eq([
                                                      :after_action,
                                                      :append_after_action,
                                                      :append_around_action,
                                                      :append_before_action,
                                                      :around_action,
                                                      :before_action,
                                                      :prepend_after_action,
                                                      :prepend_around_action,
                                                      :prepend_before_action,
                                                      :skip_after_action,
                                                      :skip_around_action,
                                                      :skip_before_action,
                                                      :skip_action_callback
                                                    ])
    end
  end

  context 'when style is action' do
    before do
      cop_config.update('EnforcedStyle' => 'action')
    end

    described_class::FILTER_METHODS.each do |method|
      it "registers an offense for #{method}" do
        inspect_source_file(cop, "#{method} :name")
        expect(cop.offenses.size).to eq(1)
      end

      it "registers an offense for #{method} with block" do
        inspect_source_file(cop, "#{method} { |controller| something }")
        expect(cop.offenses.size).to eq(1)
      end
    end

    described_class::ACTION_METHODS.each do |method|
      it "accepts #{method}" do
        inspect_source_file(cop, "#{method} :something")
        expect(cop.offenses).to be_empty
      end
    end

    it 'auto-corrects to preferred method' do
      new_source = autocorrect_source_file(cop, 'before_filter :test')
      expect(new_source).to eq('before_action :test')
    end
  end

  context 'when style is filter' do
    before do
      cop_config.update('EnforcedStyle' => 'filter')
    end

    described_class::ACTION_METHODS.each do |method|
      it "registers an offense for #{method}" do
        inspect_source_file(cop, "#{method} :name")
        expect(cop.offenses.size).to eq(1)
      end

      it "registers an offense for #{method} with block" do
        inspect_source_file(cop, "#{method} { |controller| something }")
        expect(cop.offenses.size).to eq(1)
      end
    end

    described_class::FILTER_METHODS.each do |method|
      it "accepts #{method}" do
        inspect_source_file(cop, "#{method} :something")
        expect(cop.offenses).to be_empty
      end
    end

    it 'auto-corrects to preferred method' do
      new_source = autocorrect_source_file(cop, 'before_action :test')
      expect(new_source).to eq('before_filter :test')
    end
  end
end
