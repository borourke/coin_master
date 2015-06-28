class AccountsController < ApplicationController
  def general_ledger
    if current_user
      @transactions = GeneralLedger.order(:date).decorate
    else
      redirect_to log_in_path
    end
  end

  def new_transaction
    @transaction = GeneralLedger.new
  end

  def save_transaction
    GeneralLedger.create(user_params)
    redirect_to general_ledger_path
  end

  private

    def user_params
      params.require(:general_ledger).permit(:user_id, :name, :kind, :amount,
        :date, :recurring, :category)
    end
end