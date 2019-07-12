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

  describe '#defects_by_status' do
    it 'returns all defects that belong to the given scheme with the given status' do
      outstanding_defect = create(:property_defect, property: property, priority: priority, status: :outstanding)
      closed_defect = create(:property_defect, property: property, priority: priority, status: :closed)

      result = described_class.new(scheme: scheme).defects_by_status(text: 'outstanding')
      expect(result).to include(outstanding_defect)
      expect(result).not_to include(closed_defect)
    end

    context 'when the status is closed' do
      it 'does not return an inflated number' do
        create(:property_defect, property: property, priority: priority, status: :outstanding)
        create(:property_defect, property: property, priority: priority, status: :completed)
        create(:property_defect, property: property, priority: priority, status: :closed)
        create(:property_defect, property: property, priority: priority, status: :closed)
        result = described_class.new(scheme: scheme).defects_by_status(text: 'closed')
        expect(result.count).to eql(2)
      end
    end
  end

  describe '#defects_by_trade' do
    it 'returns a count for all defects for the given trade' do
      electrical_defect = create(:property_defect, property: property, trade: 'Electrical')
      plumbing_defect = create(:property_defect, property: property, trade: 'Plumbing')

      result = described_class.new(scheme: scheme).defects_by_trade(text: 'Plumbing')

      expect(result).to include(plumbing_defect)
      expect(result).not_to include(electrical_defect)
    end
  end

  describe '#trade_percentage' do
    it 'returns the percentage of defects with this trade ' do
      create(:property_defect, property: property, trade: 'Plumbing')
      create(:property_defect, property: property, trade: 'Electrical')
      result = described_class.new(scheme: scheme).trade_percentage(text: 'Electrical')
      expect(result).to eql('50.0%')
    end

    context 'when there the total defect count is odd' do
      it 'returns a rounded percentage%' do
        create(:property_defect, property: property, trade: 'Electrical')
        create(:property_defect, property: property, trade: 'Plumbing')
        create(:property_defect, property: property, trade: 'Plumbing')
        result = described_class.new(scheme: scheme).trade_percentage(text: 'Electrical')
        expect(result).to eql('33.33%')
      end
    end

    context 'when there are no defects with that trade' do
      it 'returns 0.0%' do
        result = described_class.new(scheme: scheme).trade_percentage(text: 'Electrical')
        expect(result).to eql('0.0%')
      end
    end
  end

  describe '#defects_by_priority' do
    let(:second_priority) { create(:priority, scheme: scheme) }

    it 'returns a count for all defects for the given priority' do
      first_priority_defect = create(:property_defect, property: property, priority: priority)
      second_priority_defect = create(:property_defect, property: property, priority: second_priority)

      result = described_class.new(scheme: scheme).defects_by_priority(priority: priority)

      expect(result).to include(first_priority_defect)
      expect(result).not_to include(second_priority_defect)
    end
  end

  describe '#priority_percentage' do
    it 'returns the percentage of defects with this priority ' do
      create(:property_defect, property: property, priority: priority)
      result = described_class.new(scheme: scheme).priority_percentage(priority: priority)
      expect(result).to eql('100.0%')
    end

    context 'when there are no defects with that priority' do
      it 'returns 0.0%' do
        result = described_class.new(scheme: scheme).priority_percentage(priority: priority)
        expect(result).to eql('0.0%')
      end
    end
  end
end
