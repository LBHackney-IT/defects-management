class Comment < ApplicationRecord
  validates :message, presence: true

  belongs_to :user, dependent: false
  belongs_to :defect, dependent: :destroy

  include PublicActivity::Model
  tracked owner: ->(controller, _) { controller.current_user if controller }
end
