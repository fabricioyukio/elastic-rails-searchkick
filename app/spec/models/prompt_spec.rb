# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Prompt, type: :model do
  subject { Prompt.new(original_index: 42, content: "Lorem ipsum" )}

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is original_index to 0 when an Integer is not given for original_index' do
    subject.original_index = nil
    expect(subject).to be_valid
    expect(subject.original_index).to be(0)
  end

  it 'is not valid when a not numeric value is given for original_index' do
    subject.original_index = 'some value'
    expect(subject).not_to be_valid
  end

  it 'is not valid when a Non-Integer number for original_index is given' do
    subject.original_index = 9_999_999_999_999_999_999.3
    expect(subject).not_to be_valid
  end

  it 'requires at least 3 characters for content, but no more than 512' do
    subject.content = '12'
    expect(subject).not_to be_valid
    subject.content = '123'
    expect(subject).to be_valid
    subject.content = ((1..50).to_a).join(' ') * 6
    expect(subject).not_to be_valid
  end
end

# testing searchkick
RSpec.describe Prompt, search: true do
  it 'searches' do
    Prompt.create(original_index: 10, content: 'SweetAgentinianApple plus something else')
    Prompt.search_index.refresh
    Prompt.reindex
    mapped_content = Prompt.search('sweetagentinianapple').map(&:content)
    expect(mapped_content.join(' + ')).to include('SweetAgentinianApple')
  end
  it 'should update ES when the object is destroyed' do
    test_prompt = Prompt.create(
      original_index: 10,
      content: 'SweetAgentinianApple plus something else')
    Prompt.search_index.refresh
    Prompt.reindex
    test_prompt.destroy!
    Prompt.search_index.refresh
    Prompt.reindex
    expect(Prompt.search('SweetAgentinianApple').length).to eq(0)
  end
end