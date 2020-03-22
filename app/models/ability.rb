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
        can [:read, :update, :create, :destroy], User, organization_id: admin_user.organization_id
        can [:read, :update, :create, :destroy], Course, organization_id: admin_user.organization_id
        can [:read, :update, :create, :destroy], CourseEvent, organization_id: admin_user.organization_id
        can [:read, :update, :create, :destroy], CourseSchedule, organization_id: admin_user.organization_id
        can [:read, :update, :create, :destroy], Room, organization_id: admin_user.organization_id
        can [:read, :update, :create, :destroy], Trainer, organization_id: admin_user.organization_id
        can [:read], Category, organization_id: admin_user.organization_id
        can [:read], Product, organization_id: admin_user.organization_id
        can [:read], Subscription, organization_id: admin_user.organization_id
      end
      if admin_user.has_role? :accountant
        can [:read], Organization, id: admin_user.organization_id
        can [:read, :update], User, organization_id: admin_user.organization_id
        can [:read], Course, organization_id: admin_user.organization_id
        can [:read, :update], CourseEvent, organization_id: admin_user.organization_id
        can [:read, :update, :create, :destroy], Category, organization_id: admin_user.organization_id
        can [:read, :update, :create, :destroy], Product, organization_id: admin_user.organization_id
        can [:read, :update, :create, :destroy], Subscription, organization_id: admin_user.organization_id
      end
    end
  end
end
