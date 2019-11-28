require 'rails_helper'

RSpec.describe DueSoonAndOverdueDefectsMailer, type: :mailer do
  before(:each) do
    stub_const('NOTIFY_DAILY_DUE_SOON_TEMPLATE', '')
    stub_const('NBT_GROUP_EMAIL', 'test@email.com')
  end

  let(:property_defects) { create_list(:property_defect, 2) }
  let(:defects) { property_defects.map { |defect| DefectPresenter.new(defect) } }


  describe('#notify') do
    it 'sends an email to contractors' do
      mail = DueSoonAndOverdueDefectsMailer.notify(defects.pluck(:id))
      body_lines = mail.body.raw_source.lines

      expect(mail.subject).to eq(I18n.t('email.defects.due_soon_and_overdue.subject'))
      expect(mail.to).to eq([NBT_GROUP_EMAIL])
      expect(body_lines[0].strip).to match(/# #{I18n.t('app.title')}/)
      expect(body_lines[2].strip).to match(I18n.t('email.defects.due_soon_and_overdue.heading'))

      expect(body_lines[4].strip).to include(defects.first.created_at)
      expect(body_lines[4].strip).to include(defects.first.title)
      expect(body_lines[4].strip).to include(defects.first.trade)
      expect(body_lines[4].strip).to include(defects.first.status)
      expect(body_lines[4].strip).to include(defects.first.priority.name)

      expect(body_lines[7].strip).to include(defects.last.created_at)
      expect(body_lines[7].strip).to include(defects.last.title)
      expect(body_lines[7].strip).to include(defects.last.trade)
      expect(body_lines[7].strip).to include(defects.last.status)
      expect(body_lines[7].strip).to include(defects.last.priority.name)
    end
  end
end
