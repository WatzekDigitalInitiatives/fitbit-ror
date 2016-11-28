class FixSubscriptionTypo < ActiveRecord::Migration
  def change
    rename_column :subscriptions, :earliest, :earliest_date
  end
end
