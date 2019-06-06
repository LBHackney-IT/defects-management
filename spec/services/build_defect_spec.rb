require 'rails_helper'

RSpec.describe BuildDefect do
  let(:property) { create(:property) }
  let(:priority) { create(:priority) }
  let(:defect_params) do
    build(:defect,
          property: property,
          priority: priority).attributes
  end

  describe '.initialize' do
    it 'accepts and stores the defect_params' do
      result = described_class.new(defect_params: defect_params)

      expect(result.defect_params).to eq(defect_params)
    end
  end

  describe '#call' do
    let(:service) do
      described_class.new(defect_params: defect_params)
    end

    it 'returns a defect object' do
      expect(service.call).to be_kind_of(Defect)
    end

    it 'creates an association to the property' do
      result = service.call
      expect(result.property).to eq(property)
    end

    it 'creates an association to the priority' do
      result = service.call
      expect(result.priority).to eq(priority)
    end
  end
end