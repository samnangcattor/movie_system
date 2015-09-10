class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    if user.admin?
      can :manage, :all
    else
      can :manage, [Like, MovieHistory, Review, Comment, Request], user_id: user.id
      can :read, :all
    end
  end
end
