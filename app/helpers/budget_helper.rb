module BudgetHelper

  def total_claimed_for(event, user)
    Preference.where(giver: user, event: event).sum(:cost)
  end

  def total_purchased_for(event, user)
    Preference.where(giver: user, event: event, purchased: true).sum(:cost)
  end

  def remaining_budget_for(event_user)
    return nil unless event_user&.budget.present?

    purchased_total = total_purchased_for(event_user.event, event_user.user)
    event_user.budget - purchased_total
  end

end
