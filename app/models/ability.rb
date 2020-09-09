# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(admin_user)
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    alias_action :batch_action, to: :update

    admin_user ||= AdminUser.new

    if admin_user.is_root?
      can :manage, :all
    else
      can :read, ActiveAdmin::Page, name: "Dashboard"
      if admin_user.has_role? :manager
        can [:read, :update], Organization, id: admin_user.organization_id
        can [:read, :update, :destroy], User, organization_id: admin_user.organization_id
        can [:create], User
        can [:read, :update, :destroy], Course, organization_id: admin_user.organization_id
        can [:create], Course
        can [:read, :update, :destroy], CourseEvent, organization_id: admin_user.organization_id
        can [:create], CourseEvent
        can [:read, :update, :destroy], CourseSchedule, organization_id: admin_user.organization_id
        can [:create], CourseSchedule
        can [:read, :update, :destroy], Room, organization_id: admin_user.organization_id
        can [:create], Room
        can [:read, :update, :destroy], Trainer, organization_id: admin_user.organization_id
        can [:create], Trainer
        can [:read, :update, :destroy], UserDocumentModel, organization_id: admin_user.organization_id
        can [:create], UserDocumentModel
        can [:read, :update, :destroy], UserDocument, organization_id: admin_user.organization_id
        can [:create], UserDocument
        can [:read, :update, :destroy], Attendee, organization_id: admin_user.organization_id
        can [:create], Attendee
        # Accountant resources
        can [:read], Category, organization_id: admin_user.organization_id
        can [:read], Product, organization_id: admin_user.organization_id
        can [:read], Subscription, organization_id: admin_user.organization_id
        can [:read], Order, organization_id: admin_user.organization_id
        can [:read], OrderProduct, organization_id: admin_user.organization_id
        can [:read], Payment, organization_id: admin_user.organization_id
      end
      if admin_user.has_role? :accountant
        can [:read], Organization, id: admin_user.organization_id
        can [:read, :update], User, organization_id: admin_user.organization_id
        can [:read], Course, organization_id: admin_user.organization_id
        can [:read, :update], CourseEvent, organization_id: admin_user.organization_id
        can [:read, :update], Attendee, organization_id: admin_user.organization_id
        can [:read], CourseSchedule, organization_id: admin_user.organization_id
        can [:read], Room, organization_id: admin_user.organization_id
        can [:read], Trainer, organization_id: admin_user.organization_id
        can [:read, :update, :destroy], Category, organization_id: admin_user.organization_id
        can [:create], Category
        can [:read, :update, :destroy], Product, organization_id: admin_user.organization_id
        can [:create], Product
        can [:read, :update, :destroy], Subscription, organization_id: admin_user.organization_id
        can [:create], Subscription
        can [:read, :update, :destroy], Order, organization_id: admin_user.organization_id
        can [:create], Order
        can [:read, :update, :destroy], OrderProduct, organization_id: admin_user.organization_id
        can [:create], OrderProduct
        can [:read, :update, :destroy], Payment, organization_id: admin_user.organization_id
        can [:create], Payment
      end
    end
  end
end
