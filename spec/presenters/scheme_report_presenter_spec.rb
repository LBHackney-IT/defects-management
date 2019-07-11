require 'rails_helper'

RSpec.describe SchemeReportPresenter do
  let(:scheme) { create(:scheme) }
  let(:property) { create(:property, scheme: scheme) }
  let(:priority) { create(:priority, scheme: scheme) }

  describe '#defects' do
    let(:defect) { create(:property_defect, property: property, priority: priority) }
    it 'returns all defects for the given scheme' do
      result = described_class.new(scheme: defect.scheme).defects
      expect(result).to include(defect)
    end
  end

  describe '#date_range' do
    it 'returns a time range for all the data being viewed in a string format' do
      start_time = Time.utc(2018, 1, 1, 13)
      scheme = create(:scheme, created_at: start_time)
      result = described_class.new(scheme: scheme).date_range
      expect(result).to eq("From #{start_time} to #{Time.current}")
    end
  end
end
