class GeneralLedger < ActiveRecord::Base
  belongs_to :user

  scope :this_month, -> { where('date >= ?', Date.today.at_beginning_of_month) }

  def self.apply_filters(params)
    @params ||= params
    if params.nil?
      # want to do this for the futre: this_month
      # but until it's getting used heavily:
      all
    else
      self.person.kind
    end
  end

  def self.person
    if !@params[:filters][:name].blank?
      where(user_id: User.find_by_name(@params[:filters][:name]).id)
    else
      all
    end
  end

  def self.kind
    if !@params[:filters][:kind].blank?
      where(kind: @params[:filters][:kind])
    else
      all
    end
  end
end