class FixSubscriptionTypo < ActiveRecord::Migration
  def change
    rename_column :subscriptions, :earlist_date, :earliest_date
  end
end
