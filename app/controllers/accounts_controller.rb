class AccountsController < ApplicationController
  def general_ledger
    @transactions = GeneralLedger.order(:date).decorate
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
        :date, :recurring)
    end
end