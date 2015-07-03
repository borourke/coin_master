class GeneralLedgerSummary
  attr_reader :summary_hash

  SUMMARY_HASH_KEYS = %w(
    total_receivable 
    total_payable 
    total_net
    monthly_recurring_receivable
    monthly_recurring_payable
    last_month_discresionary_payable
    num_months_forecasting
    forecasted_amount
  )

  def initialize(forecasted_date)
    @forecasted_date = forecasted_date
    @summary_hash = build_summary_hash
  end

  def build_summary_hash
    SUMMARY_HASH_KEYS.each_with_object({}) do |key, summary_hash|
      summary_hash[key.to_sym] = send(key)
    end
  end

  def general_ledger
    @general_ledger ||= GeneralLedger.all
  end

  def total_receivable
    general_ledger.receivable.pluck(:amount).inject{ |sum, amount| sum + amount }
  end

  def total_payable
    general_ledger.payable.pluck(:amount).inject{ |sum, amount| sum + amount }
  end

  def total_net
    total_receivable - total_payable
  end

  def monthly_recurring_receivable
    general_ledger.last_month.recurring.receivable.pluck(:amount).inject{ |sum, amount| sum + amount } || 0
  end

  def monthly_recurring_payable
    general_ledger.last_month.recurring.payable.pluck(:amount).inject{ |sum, amount| sum + amount } || 0
  end

  def last_month_discresionary_payable
    general_ledger.last_month.payable.pluck(:amount).inject{ |sum, amount| sum + amount } || 0
  end

  def num_months_forecasting
    @forecasted_date.month - Date.today.month
  end

  def forecasted_amount
    num_months_forecasting.to_f * (monthly_recurring_receivable - monthly_recurring_payable - last_month_discresionary_payable)
  end
end