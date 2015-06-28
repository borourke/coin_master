class GeneralLedgerDecorator < Draper::Decorator
  delegate_all

  def formatted_date
    date.strftime('%B %d, %Y')
  end
end
