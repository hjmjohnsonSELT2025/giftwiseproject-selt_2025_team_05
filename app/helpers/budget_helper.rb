module BudgetHelper
  def total_claimed_for(event, user)
    pref_total = Preference.where(giver: user, event: event).sum(:cost)
    sugg_total = Suggestion.where(user: user, event: event).sum(:cost)
    pref_total + sugg_total
  end

  def total_purchased_for(event, user)
    pref_total = Preference.where(giver: user, event: event, purchased: true).sum(:cost)
    sugg_total = Suggestion.where(user: user, event: event, purchased: true).sum(:cost)
    pref_total + sugg_total
  end

  def remaining_budget_for(event_user)
    return 0 unless event_user

    budget = event_user.budget || 0
    purchased = total_purchased_for(event_user.event, event_user.user) || 0

    budget - purchased
  end

  def can_claim_gift?(event, user, gift_cost)
    event_user = event.event_users.find_by(user: user)
    return false unless event_user
    return true unless event_user.budget.present?

    claimed_total = total_claimed_for(event, user)
    (claimed_total + gift_cost) <= event_user.budget
  end
end
