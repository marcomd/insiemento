class AdminUser < ApplicationRecord
  belongs_to :organization, optional: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :trackable

  ROLES = %w[root manager accountant].freeze
  scope :with_role, ->(role) { where("roles_mask & #{2**ROLES.index(role.to_s)} > 0 ") }
  scope :without_role, ->(role) { where("roles_mask & #{2**ROLES.index(role.to_s)} = 0 ") }

  def fullname
    "#{firstname} #{lastname}"
  end

  def roles=(roles)
    self.roles_mask = (roles & ROLES).sum { |r| 2**ROLES.index(r) }
  end

  def roles
    ROLES.reject { |r| ((roles_mask || 0) & (2**ROLES.index(r))).zero? }
  end

  def has_role?(role)
    roles.include?(role.to_s)
  end

  def is_root?
    has_role?('root')
  end

  def categories
    is_root? ? Category.all : organization&.categories || []
  end

  def courses
    is_root? ? Course.all : organization&.courses || []
  end

  def rooms
    is_root? ? Room.all : organization&.rooms || []
  end

  def trainers
    is_root? ? Trainer.all : organization&.trainers || []
  end

  def course_schedules
    is_root? ? CourseSchedule.all : organization&.course_schedules || []
  end

  def users
    is_root? ? User.all : organization&.users || []
  end

  def products
    is_root? ? Product.all : organization&.products || []
  end

  def subscriptions
    is_root? ? Product.all : organization&.products || []
  end

  def orders
    is_root? ? Order.all : organization&.orders || []
  end

  def payments
    is_root? ? Payment.all : organization&.payments || []
  end

  def user_document_models
    is_root? ? UserDocumentModel.all : organization&.user_document_models || []
  end
end
