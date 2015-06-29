class GeneralLedgerDecorator < Draper::Decorator
  delegate_all

  def formatted_date
    date.strftime('%B %d, %Y')
  end

  def categories
    GeneralLedger.pluck(:category).uniq
  end

  def months
    GeneralLedger.pluck(:date).map{ |date| date.strftime('%B - %Y') }.uniq
  end
end
