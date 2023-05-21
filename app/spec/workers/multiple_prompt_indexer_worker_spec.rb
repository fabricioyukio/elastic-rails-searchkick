# frozen_string_literal: true

require 'rails_helper' # include in your RSpec file
require 'sidekiq/testing' # include in your Rspec file

Sidekiq::Testing.fake! # include in your RSpec file

RSpec.describe MultiplePromptIndexerWorker, type: :worker do
  it { is_expected.to be_processed_in :searchkick }
  it { is_expected.to be_retryable 5 }

  let(:prompt) { Prompt.create(original_index: 42, content: 'Lorem ipsum 0099999') }
  let(:time) { (Time.zone.today + 6.hours).to_datetime }
  let(:scheduled_job) { described_class.perform_at(time, 'ipsum 0099999', true) }

  describe 'testing worker' do
    it 'MultiplePromptIndexerWorker jobs are enqueued in the searchkick queue' do
      described_class.perform_async 'ipsum 0099999', true # enqueues the job
      assert_equal :searchkick, described_class.queue
    end

    it 'goes into the jobs array for testing environment' do
      expect do
        described_class.perform_async 'ipsum 0099999', true
      end.to change(described_class.jobs, :size).by_at_least(1)
    end

    context 'occurs daily' do
      it 'occurs at expected time' do
        scheduled_job
        assert_equal true, described_class.jobs.last['jid'].include?(scheduled_job)
        expect(described_class).to have_enqueued_sidekiq_job('ipsum 0099999', true)
      end
    end
  end
end
