class AdminUser < ApplicationRecord
  belongs_to :organization, optional: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  ROLES = %w[root manager accountant]
  scope :with_role   , ->(role) { where("roles_mask & #{2**ROLES.index(role.to_s)} > 0 ") }
  scope :without_role, ->(role) { where("roles_mask & #{2**ROLES.index(role.to_s)} = 0 ") }

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  def has_role?(role)
    roles.include? role.to_s
  end

  def is_root?
    self.has_role? 'root'
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


end
