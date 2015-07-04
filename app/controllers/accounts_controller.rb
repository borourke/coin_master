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
      @forecast_date = params[:forecast] ? params[:forecast][:date] : (Date.today + 3.months).at_beginning_of_month
      @summary_hash = GeneralLedgerSummary.new(@forecast_date).summary_hash
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
      income = transactions.select{ |transaction| transaction.kind == "Income"}.map{ |transaction| transaction.amount }.inject{ |sum, amount| sum + amount }
      expense = transactions.select{ |transaction| transaction.kind == "Expense"}.map{ |transaction| transaction.amount }.inject{ |sum, amount| sum + amount }
      income.to_i - expense.to_i
    end
end