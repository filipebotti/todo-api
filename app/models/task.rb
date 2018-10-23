class Task < ApplicationRecord
  belongs_to :user

  scope :all_tasks, -> (user) { where(user_id: user.id) }
  scope :user_tasks, -> (user) { all_tasks(user).where(deleted_at: nil) }  
  scope :discarded, -> (user) { all_tasks(user).where.not(deleted_at: nil)}

  validates :description, presence: true
  validates :user, presence: true

  def discard
    self.deleted_at = DateTime.now
    self.save
  end
end
