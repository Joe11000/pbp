class Ability
  include CanCan::Ability

  def initialize(user)
    @current_user ||= User.first
    
    if @current_user
      can [:edit, :update, :destroy], Project, owner_id: @current_user.id 

      can [:update, :destroy], Donation, user_id: @current_user.id
      can :create, Donation
    else
      can :create, User
    end
  end
end
