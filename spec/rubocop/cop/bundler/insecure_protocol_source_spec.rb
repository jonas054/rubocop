# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bundler::InsecureProtocolSource do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using `source :gemcutter`' do
    expect_offense do
      source :gemcutter
      #      ^^^^^^^^^^ The source `:gemcutter` is deprecated because HTTP requests are insecure. Please change your source to 'https://rubygems.org' if possible, or 'http://rubygems.org' if not.
    end
  end

  it 'registers an offense when using `source :rubygems`' do
    expect_offense do
      source :rubygems
      #      ^^^^^^^^^ The source `:rubygems` is deprecated because HTTP requests are insecure. Please change your source to 'https://rubygems.org' if possible, or 'http://rubygems.org' if not.
    end
  end

  it 'registers an offense when using `source :rubyforge`' do
    expect_offense do
      source :rubyforge
      #      ^^^^^^^^^^ The source `:rubyforge` is deprecated because HTTP requests are insecure. Please change your source to 'https://rubygems.org' if possible, or 'http://rubygems.org' if not.
    end
  end

  it 'autocorrects `source :gemcutter`' do
    new_source = autocorrect_source('source :gemcutter')

    expect(new_source).to eq("source 'https://rubygems.org'")
  end

  it 'autocorrects `source :rubygems`' do
    new_source = autocorrect_source('source :rubygems')

    expect(new_source).to eq("source 'https://rubygems.org'")
  end

  it 'autocorrects `source :rubyforge`' do
    new_source = autocorrect_source('source :rubyforge')

    expect(new_source).to eq("source 'https://rubygems.org'")
  end
end
