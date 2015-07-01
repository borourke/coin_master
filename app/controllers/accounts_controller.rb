class AccountsController < ApplicationController
  def general_ledger
    if current_user
      @transactions = GeneralLedger.order(:date).decorate
      @transaction = GeneralLedger.new
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

  private

    def user_params
      params[:general_ledger][:date] = DateTime.parse(params[:general_ledger][:date])
      params.require(:general_ledger).permit(:user_id, :name, :kind, :amount,
        :date, :recurring, :category)
    end
end