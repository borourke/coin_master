class AccountsController < ApplicationController
  def general_ledger
    if current_user
      @transactions = GeneralLedger.apply_filters(params[:filters]).decorate
      @transaction = GeneralLedger.new
      @net_total = net_total(@transactions)
      @current = :general_ledger
    else
      redirect_to log_in_path
    end
  end

  def delete_transaction
    if current_user
      GeneralLedger.find(params[:id]).destroy
    end
    redirect_to general_ledger_path
  end

  def save_transaction
    if current_user
      GeneralLedger.create(user_params)
    end
    redirect_to general_ledger_path
  end

  def summary
    if current_user
      @current = :summary
      @forecast_date = params[:custom_forecast_date] ? Date.parse(params[:custom_forecast_date][:custom_month]) : (Date.today + 3.months).at_beginning_of_month
      @summary_hash = GeneralLedgerSummary.new(@forecast_date).summary_hash
      @next_years_months = next_years_months
    else
      redirect_to log_in_path
    end
  end

  private

    def user_params
      params[:general_ledger][:date] = DateTime.parse(params[:general_ledger][:date])
      params.require(:general_ledger).permit(:user_id, :name, :kind, :amount,
        :date, :recurring, :category)
    end

    def net_total(transactions)
      sum_amount(transactions, "Income").to_i - sum_amount(transactions, "Expense").to_i
    end

    def sum_amount(transactions, kind)
      transactions.select{ |transaction| transaction.kind == kind}.map{ |transaction| transaction.amount }.inject{ |sum, amount| sum + amount }
    end

    def next_years_months
      (1..12).each_with_object([]) do |month_step, months_array|
        months_array << (Date.today.at_beginning_of_month + month_step.months).strftime('%B - %Y')
      end
    end
end