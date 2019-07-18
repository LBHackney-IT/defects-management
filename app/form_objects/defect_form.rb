class DefectForm
  include ActiveModel::Model

  attr_accessor :defect

  delegate(*Defect.attribute_names.map { |attr| [attr, "#{attr}=", "#{attr}?"] }.flatten, to: :defect)
  delegate :priority, to: :defect
  delegate :save, to: :defect

  def initialize(defect:)
    @defect = defect
  end
end
