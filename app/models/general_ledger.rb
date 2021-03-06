class GeneralLedger < ActiveRecord::Base
  belongs_to :user

  scope :this_month, -> { where('date >= ?', Date.today.at_beginning_of_month) }
  scope :last_month, -> { where('date >= ? and date < ?', Date.today.at_beginning_of_month - 1.month, Date.today.at_beginning_of_month) }
  scope :recurring, -> { where(recurring: true) }
  scope :payable, -> { where(kind: 'Expense') }
  scope :receivable, -> { where(kind: 'Income') }

  def self.apply_filters(params)
    if params
      @params = params.reject { |key, value| value.empty? }
      general_ledger = @params.empty? ? GeneralLedger.all : GeneralLedger.where(self.build_filters_query)
      general_ledger.order(:date)
    else
      GeneralLedger.this_month.order(:date)
    end
  end

  def self.build_filters_query
    test = [
      self.filter_person, 
      self.filter_kind, 
      self.filter_name,
      self.filter_amount,
      self.filter_recurring,
      self.filter_category,
      self.filter_date
    ].compact.join(" and ")
  end

  def self.filter_person
    if @params[:name]
      "user_id = #{User.find_by_name(@params[:name]).id}"
    end
  end

  def self.filter_kind
    if @params[:kind]
      "kind = '#{@params[:kind]}'"
    end
  end

  def self.filter_name
    if @params[:search]
      "LOWER(name) like LOWER('%#{@params[:search]}%')"
    end
  end

  def self.filter_amount
    if @params[:amount]
      "amount #{@params[:amount]}"
    end
  end

  def self.filter_category
    if @params[:category]
      "category = '#{@params[:category]}'"
    end
  end

  def self.filter_recurring
    if @params[:recurring]
      "recurring = #{@params[:recurring]}"
    end
  end

  def self.filter_date
    if @params[:date]
      formatted_date = DateTime.parse(@params[:date]).beginning_of_month
      ending_date = formatted_date + 1.month
      "date >= '#{formatted_date}' and date < '#{ending_date}'"
    end
  end
end